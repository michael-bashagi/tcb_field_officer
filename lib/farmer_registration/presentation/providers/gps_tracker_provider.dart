import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/farm.dart';

class GpsTrackerState {
  final bool isTracking;
  final BoundaryPoint? currentPosition;
  final List<BoundaryPoint> capturedPoints;
  final double calculatedAcreage;
  final String? error;

  const GpsTrackerState({
    this.isTracking = false,
    this.currentPosition,
    this.capturedPoints = const [],
    this.calculatedAcreage = 0.0,
    this.error,
  });

  bool get isValidPolygon => capturedPoints.length >= 3;

  GpsTrackerState copyWith({
    bool? isTracking,
    BoundaryPoint? currentPosition,
    List<BoundaryPoint>? capturedPoints,
    double? calculatedAcreage,
    String? error,
  }) {
    return GpsTrackerState(
      isTracking: isTracking ?? this.isTracking,
      currentPosition: currentPosition ?? this.currentPosition,
      capturedPoints: capturedPoints ?? this.capturedPoints,
      calculatedAcreage: calculatedAcreage ?? this.calculatedAcreage,
      error: error,
    );
  }
}

class GpsTrackerNotifier extends StateNotifier<GpsTrackerState> {
  GpsTrackerNotifier() : super(const GpsTrackerState());

  void startTracking() {
    state = state.copyWith(isTracking: true, error: null);
  }

  void stopTracking() {
    state = state.copyWith(isTracking: false);
  }

  void addPoint(BoundaryPoint point) {
    final updatedList = List<BoundaryPoint>.from(state.capturedPoints)
      ..add(point);
    final acreage = _calculateAcreageInAcres(updatedList);

    state = state.copyWith(
      currentPosition: point,
      capturedPoints: updatedList,
      calculatedAcreage: acreage,
    );
  }

  void removeLastPoint() {
    if (state.capturedPoints.isEmpty) return;

    final updatedList = List<BoundaryPoint>.from(state.capturedPoints)
      ..removeLast();
    final acreage = _calculateAcreageInAcres(updatedList);

    state = state.copyWith(
      capturedPoints: updatedList,
      calculatedAcreage: acreage,
    );
  }

  void reset() {
    state = const GpsTrackerState();
  }

  Farm toFarm({required String locationFromGeospatial}) {
    double centerLat = 0.0;
    double centerLng = 0.0;

    if (state.capturedPoints.isNotEmpty) {
      centerLat =
          state.capturedPoints.map((p) => p.latitude).reduce((a, b) => a + b) /
              state.capturedPoints.length;
      centerLng =
          state.capturedPoints.map((p) => p.longitude).reduce((a, b) => a + b) /
              state.capturedPoints.length;
    }

    return Farm(
      sizeInAcres: state.calculatedAcreage,
      latitude: centerLat,
      longitude: centerLng,
      locationFromGeospatial: locationFromGeospatial,
      boundaryPoints: state.capturedPoints,
    );
  }

  double _calculateAcreageInAcres(List<BoundaryPoint> points) {
    if (points.length < 3) return 0.0;

    const double earthRadiusMeters = 6378137.0;
    double areaSqMeters = 0.0;

    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];

      final lat1Rad = p1.latitude * math.pi / 180.0;
      final lat2Rad = p2.latitude * math.pi / 180.0;
      final deltaLngRad = (p2.longitude - p1.longitude) * math.pi / 180.0;

      areaSqMeters += deltaLngRad * (2 + math.sin(lat1Rad) + math.sin(lat2Rad));
    }

    areaSqMeters =
        (areaSqMeters * earthRadiusMeters * earthRadiusMeters / 2.0).abs();

    final acres = areaSqMeters / 4046.85642;
    return double.parse(acres.toStringAsFixed(2));
  }
}

final gpsTrackerProvider =
    StateNotifierProvider<GpsTrackerNotifier, GpsTrackerState>((ref) {
  return GpsTrackerNotifier();
});
