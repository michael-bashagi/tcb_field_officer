import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_provider.dart';
import '../../features/home/presentation/home_providers.dart';
import '../../routing/app_router.dart';
import '../data/farm_repository.dart';
import '../domain/farm.dart';
import '../domain/farmer_request.dart';
import '../domain/named_ref.dart';
import 'gps_boundary_walker_screen.dart';

class FarmerRegistrationBottomSheet extends ConsumerStatefulWidget {
  const FarmerRegistrationBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final topSafeArea = MediaQuery.of(context).padding.top;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - topSafeArea - 80,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const FarmerRegistrationBottomSheet(),
      ),
    );
  }

  @override
  ConsumerState<FarmerRegistrationBottomSheet> createState() =>
      _FarmerRegistrationBottomSheetState();
}

class _FarmerRegistrationBottomSheetState
    extends ConsumerState<FarmerRegistrationBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  Farm? _demarcatedFarm;
  NamedRef? _selectedCottonDistrict;

  NamedRef? _selectedRegion;
  NamedRef? _selectedDistrict;
  NamedRef? _selectedWard;
  NamedRef? _selectedSubWard;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _capitalize(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  Future<void> _startDemarcation() async {
    final farm = await Navigator.of(context).push<Farm>(
      MaterialPageRoute(builder: (_) => const GpsBoundaryWalkerScreen()),
    );
    if (farm != null && mounted) {
      setState(() => _demarcatedFarm = farm);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields above.'),
        ),
      );
      return;
    }
    if (_demarcatedFarm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please demarcate the farm boundary.')),
      );
      return;
    }
    if (_selectedCottonDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select the farm\'s cotton district.')),
      );
      return;
    }
    if (_selectedSubWard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the farm\'s sub-ward.')),
      );
      return;
    }

    final officerName = ref.read(currentOfficerProvider)?.name ?? '';
    final request = FarmerRequest(
      firstName: _capitalize(_firstNameController.text.trim()),
      middleName: _capitalize(_middleNameController.text.trim()),
      lastName: _capitalize(_lastNameController.text.trim()),
      phoneNumber: _phoneController.text.trim(),
      registeredByFieldOfficer: officerName,
      farm: _demarcatedFarm!,
    );

    setState(() => _isSubmitting = true);
    try {
      final registered =
          await ref.read(farmRepositoryProvider).registerFarmerWithFarm(
                farmer: request,
                agriculturalZoneUid: _selectedCottonDistrict!.uid,
                subWardUid: _selectedSubWard!.uid,
              );
      ref.invalidate(homeMetricsProvider);
      ref.invalidate(myFarmersProvider);

      if (!mounted) return;
      Navigator.of(context).pop();
      context.push(AppRoutes.registrationDetails, extra: registered);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Failed to register farmer'),
          content: SingleChildScrollView(
            child: SelectableText(e.toString()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDisabledField(String hint) {
    return InputDecorator(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      child: Text(hint, style: TextStyle(color: Colors.grey[500])),
    );
  }

  Widget _buildNamedRefDropdown({
    required String label,
    required AsyncValue<List<NamedRef>> asyncItems,
    required NamedRef? value,
    required ValueChanged<NamedRef?> onChanged,
  }) {
    return asyncItems.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, stackTrace) => Text(
        'Failed to load $label: $error',
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
      data: (items) => DropdownButtonFormField<NamedRef>(
        initialValue: items.contains(value) ? value : null,
        hint: Text('Select $label'),
        isExpanded: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        items: items.map((item) {
          return DropdownMenuItem<NamedRef>(
              value: item, child: Text(item.name));
        }).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2C5F2D);
    final cottonDistrictsAsync = ref.watch(cottonDistrictsProvider);
    final regionsAsync = ref.watch(regionsProvider);
    final districtsAsync = _selectedRegion == null
        ? null
        : ref.watch(districtsProvider(_selectedRegion!.uid));
    final wardsAsync = _selectedDistrict == null
        ? null
        : ref.watch(wardsProvider(_selectedDistrict!.uid));
    final subWardsAsync = _selectedWard == null
        ? null
        : ref.watch(subWardsProvider(_selectedWard!.uid));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Register Farmer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303D2D),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _middleNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Farm Location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select the TAMISEMI administrative area the farm falls under.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                _buildNamedRefDropdown(
                  label: 'Region',
                  asyncItems: regionsAsync,
                  value: _selectedRegion,
                  onChanged: (region) => setState(() {
                    _selectedRegion = region;
                    _selectedDistrict = null;
                    _selectedWard = null;
                    _selectedSubWard = null;
                  }),
                ),
                const SizedBox(height: 10),
                districtsAsync == null
                    ? _buildDisabledField('Select a region first')
                    : _buildNamedRefDropdown(
                        label: 'District',
                        asyncItems: districtsAsync,
                        value: _selectedDistrict,
                        onChanged: (district) => setState(() {
                          _selectedDistrict = district;
                          _selectedWard = null;
                          _selectedSubWard = null;
                        }),
                      ),
                const SizedBox(height: 10),
                wardsAsync == null
                    ? _buildDisabledField('Select a district first')
                    : _buildNamedRefDropdown(
                        label: 'Ward',
                        asyncItems: wardsAsync,
                        value: _selectedWard,
                        onChanged: (ward) => setState(() {
                          _selectedWard = ward;
                          _selectedSubWard = null;
                        }),
                      ),
                const SizedBox(height: 10),
                subWardsAsync == null
                    ? _buildDisabledField('Select a ward first')
                    : _buildNamedRefDropdown(
                        label: 'Sub-Ward',
                        asyncItems: subWardsAsync,
                        value: _selectedSubWard,
                        onChanged: (subWard) =>
                            setState(() => _selectedSubWard = subWard),
                      ),
                const SizedBox(height: 20),
                const Text(
                  'Farm Assignment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                cottonDistrictsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stackTrace) => Text(
                    'Failed to load cotton districts: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                  data: (districts) => DropdownButtonFormField<NamedRef>(
                    initialValue: _selectedCottonDistrict,
                    hint: const Text('Select cotton district'),
                    isExpanded: true,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    items: districts.map((district) {
                      return DropdownMenuItem<NamedRef>(
                        value: district,
                        child: Text(district.name),
                      );
                    }).toList(),
                    onChanged: (district) =>
                        setState(() => _selectedCottonDistrict = district),
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                ),
                const SizedBox(height: 12),
                if (_demarcatedFarm != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EFE3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primaryColor),
                    ),
                    child: Text(
                      'Farm boundary captured: ${_demarcatedFarm!.locationFromGeospatial} '
                      '(${_demarcatedFarm!.sizeInAcres} Ac)',
                      style: const TextStyle(fontSize: 13, color: primaryColor),
                    ),
                  ),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _startDemarcation,
                    icon: const Icon(Icons.add_location_alt_outlined,
                        color: primaryColor),
                    label: Text(
                      _demarcatedFarm == null
                          ? 'Demarcate Farm (Walk Perimeter)'
                          : 'Re-walk Farm Boundary',
                      style: const TextStyle(color: primaryColor),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Register Farmer',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
