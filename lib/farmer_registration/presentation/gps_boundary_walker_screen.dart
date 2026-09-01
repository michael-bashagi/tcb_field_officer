import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_colors.dart';
import '../domain/farm.dart';
import 'providers/gps_tracker_provider.dart';
import 'widgets/farm_demarcation_map.dart';

class GpsBoundaryWalkerScreen extends ConsumerStatefulWidget {
  const GpsBoundaryWalkerScreen({super.key});

  @override
  ConsumerState<GpsBoundaryWalkerScreen> createState() =>
      _GpsBoundaryWalkerScreenState();
}

class _GpsBoundaryWalkerScreenState
    extends ConsumerState<GpsBoundaryWalkerScreen> {
  bool _isCapturing = false;

  @override
  void dispose() {
    ref.read(gpsTrackerProvider.notifier).reset();
    super.dispose();
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Please enable location services to walk a farm boundary.');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showError('Location permission is required to record GPS boundaries.');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleTracking() async {
    final notifier = ref.read(gpsTrackerProvider.notifier);

    if (ref.read(gpsTrackerProvider).isTracking) {
      notifier.stopTracking();
      return;
    }

    final hasPermission = await _ensureLocationPermission();
    if (!hasPermission) return;

    notifier.startTracking();
  }

  Future<void> _capturePoint() async {
    setState(() => _isCapturing = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ref.read(gpsTrackerProvider.notifier).addPoint(
            BoundaryPoint(
              latitude: position.latitude,
              longitude: position.longitude,
              altitude: position.altitude,
            ),
          );
    } catch (e) {
      _showError('Failed to get GPS location: $e');
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _finish() {
    final gpsState = ref.read(gpsTrackerProvider);
    if (!gpsState.isValidPolygon) {
      _showError('Record at least 3 boundary points before finishing.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Boundary Captured'),
        content: Text(
          '${gpsState.capturedPoints.length} points recorded.\n'
          'Estimated area: ${gpsState.calculatedAcreage} acres.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continue Editing'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final firstPoint = gpsState.capturedPoints.first;
              final locationLabel =
                  'GPS Mapped (${firstPoint.latitude.toStringAsFixed(4)}, '
                  '${firstPoint.longitude.toStringAsFixed(4)})';
              final farm = ref
                  .read(gpsTrackerProvider.notifier)
                  .toFarm(locationFromGeospatial: locationLabel);

              Navigator.of(dialogContext).pop();
              ref.read(gpsTrackerProvider.notifier).reset();
              Navigator.of(context).pop(farm);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gpsState = ref.watch(gpsTrackerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Boundary Walker'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Expanded(child: FarmDemarcationMap()),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _toggleTracking,
                          icon: Icon(gpsState.isTracking
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline),
                          label: Text(gpsState.isTracking
                              ? 'Stop Session'
                              : 'Start Session'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: gpsState.isTracking && !_isCapturing
                              ? _capturePoint
                              : null,
                          icon: _isCapturing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.add_location_alt_outlined),
                          label: const Text('Capture Point'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: gpsState.isValidPolygon ? _finish : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.goldAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Finish & Save Boundary'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
