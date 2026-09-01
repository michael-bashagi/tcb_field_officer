import 'package:flutter/foundation.dart';

@immutable
class HomeMetrics {
  final int totalFarmersRegistered;
  final double totalMappedAcreage;

  const HomeMetrics({
    required this.totalFarmersRegistered,
    required this.totalMappedAcreage,
  });
}
