import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tcb_field_officer/core/constants/app_colors.dart';

import '../../../farmer_registration/presentation/farmer_registration_screen.dart';
import '../../../routing/app_router.dart';
import '../../auth/presentation/controllers/auth_provider.dart';
import 'home_providers.dart';
import 'widgets/farmer_card_tile.dart';
import 'widgets/farmer_detail_popup.dart';
import 'widgets/farmer_search_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final officer = ref.watch(currentOfficerProvider);
    final metricsAsync = ref.watch(homeMetricsProvider);
    final farmersAsync = ref.watch(myFarmersProvider);
    final query = ref.watch(homeSearchQueryProvider).trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(officer != null ? 'Hi, ${officer.name}' : 'My Farmers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeMetricsProvider);
          ref.invalidate(myFarmersProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Metrics Overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
              ),
              const SizedBox(height: 12),
              metricsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => const Text(
                  'Unable to load your metrics. Pull down to refresh.',
                  style: TextStyle(color: Colors.red),
                ),
                data: (metrics) => Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Total Farmers',
                        value: '${metrics.totalFarmersRegistered}',
                        icon: Icons.people_alt_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Mapped Acreage',
                        value: '${metrics.totalMappedAcreage} Ac',
                        icon: Icons.map_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FarmerSearchBar(
                controller: _searchController,
                onChanged: (value) =>
                    ref.read(homeSearchQueryProvider.notifier).state = value,
                onClear: () =>
                    ref.read(homeSearchQueryProvider.notifier).state = '',
              ),
              const SizedBox(height: 16),
              Text(
                'Farmers in My Zone',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
              ),
              const SizedBox(height: 8),
              farmersAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Unable to load your farmers. Pull down to refresh.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                data: (farmers) {
                  final filtered = query.isEmpty
                      ? farmers
                      : farmers.where((farmer) {
                          return farmer.fullName
                                  .toLowerCase()
                                  .contains(query) ||
                              farmer.phoneNumber.contains(query) ||
                              farmer.farm.locationFromGeospatial
                                  .toLowerCase()
                                  .contains(query);
                        }).toList();

                  if (filtered.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.neutralBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              color: Colors.grey, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            query.isEmpty
                                ? 'No farmers registered in your zone yet.'
                                : 'No farmers match "$query".',
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final farmer = filtered[index];
                      return FarmerCardTile(
                        farmer: farmer,
                        onTap: () => FarmerDetailPopup.show(context, farmer),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Register Farmer',
        onPressed: () => FarmerRegistrationBottomSheet.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
              Icon(icon, color: AppColors.primary, size: 22),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
