import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/home_repository.dart';
import '../domain/home_metrics.dart';
import '../../../farmer_registration/data/farm_repository.dart';
import '../../../farmer_registration/domain/farmer_request.dart';

final homeMetricsProvider = FutureProvider<HomeMetrics>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getDashboardMetrics();
});

final myFarmersProvider = FutureProvider<List<FarmerRequest>>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final farmers = await repository.getMyFarmers();

  final farmRepository = ref.watch(farmRepositoryProvider);
  final enriched = <FarmerRequest>[];
  for (final farmer in farmers) {
    if (farmer.uid == null) {
      enriched.add(farmer);
      continue;
    }
    final cachedBill = await farmRepository.getCachedBill(farmer.uid!);
    enriched.add(
      cachedBill == null
          ? farmer
          : farmer.copyWith(
              controlNumber: cachedBill.controlNumber,
              paymentStatus: cachedBill.paymentStatus,
            ),
    );
  }
  return enriched;
});

final homeSearchQueryProvider = StateProvider<String>((ref) => '');
