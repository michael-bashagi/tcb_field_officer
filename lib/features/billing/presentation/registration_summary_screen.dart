import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/graphql_client.dart';
import '../../../farmer_registration/data/farm_repository.dart';
import '../../../farmer_registration/domain/farmer_request.dart';
import '../../home/presentation/home_providers.dart';

class RegistrationDetailsScreen extends ConsumerStatefulWidget {
  final FarmerRequest farmerRequest;

  const RegistrationDetailsScreen({
    super.key,
    required this.farmerRequest,
  });

  @override
  ConsumerState<RegistrationDetailsScreen> createState() =>
      _RegistrationDetailsScreenState();
}

class _RegistrationDetailsScreenState
    extends ConsumerState<RegistrationDetailsScreen> {
  bool _isGenerating = false;
  String? _generatedControlNumber;
  double? _amount;

  Future<void> _handleGenerateControlNumber() async {
    setState(() => _isGenerating = true);
    try {
      final result = await ref
          .read(farmRepositoryProvider)
          .generateControlNumber(widget.farmerRequest);

      ref.invalidate(myFarmersProvider);

      setState(() {
        _generatedControlNumber = result.controlNumber;
        _amount = result.amount;
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2C5F2D),
            content: Text(
              'Control number generated! Payment prompt sent to ${widget.farmerRequest.phoneNumber}',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userFacingErrorMessage(
              e,
              'Unable to generate the billing control number. Please try again.',
            )),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2C5F2D);
    const darkTextColor = Color(0xFF303D2D);
    const goldAccent = Color(0xFFBE822C);

    final farmer = widget.farmerRequest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Details'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE7EFE3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: primaryColor, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Farmer registered successfully.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Farmer Particulars',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('Full Name', farmer.fullName),
                    const Divider(),
                    _buildRow('Phone Number', farmer.phoneNumber),
                    const Divider(),
                    _buildRow(
                      'Registered By',
                      farmer.registeredByFieldOfficer.isNotEmpty
                          ? farmer.registeredByFieldOfficer
                          : 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Assigned Demarcated Farm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('Location (Geospatial)',
                        farmer.farm.locationFromGeospatial),
                    const Divider(),
                    _buildRow('Acreage',
                        '${farmer.farm.sizeInAcres.toStringAsFixed(2)} Acres'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            if (_generatedControlNumber != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9E7CA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: goldAccent),
                ),
                child: Column(
                  children: [
                    const Text('Billing Control Number',
                        style: TextStyle(fontSize: 12, color: darkTextColor)),
                    const SizedBox(height: 4),
                    Text(
                      _generatedControlNumber!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: goldAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (_amount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Amount: ${_amount!.toStringAsFixed(2)} TZS',
                        style:
                            const TextStyle(fontSize: 13, color: darkTextColor),
                      ),
                    ],
                    const SizedBox(height: 4),
                    const Text(
                      'Payment prompt sent to farmer phone number.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGenerating || _generatedControlNumber != null
                    ? null
                    : _handleGenerateControlNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.sms_outlined),
                label: Text(
                  _isGenerating
                      ? 'Generating Control No...'
                      : 'Generate Billing Control Number',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF303D2D),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
