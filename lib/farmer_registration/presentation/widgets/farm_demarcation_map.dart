import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/gps_tracker_provider.dart';

class FarmDemarcationMap extends ConsumerStatefulWidget {
  final MapController? mapController;

  const FarmDemarcationMap({
    super.key,
    this.mapController,
  });

  @override
  ConsumerState<FarmDemarcationMap> createState() => _FarmDemarcationMapState();
}

class _FarmDemarcationMapState extends ConsumerState<FarmDemarcationMap> {
  late final MapController _internalMapController;

  @override
  void initState() {
    super.initState();
    _internalMapController = widget.mapController ?? MapController();
  }

  @override
  Widget build(BuildContext context) {
    final gpsState = ref.watch(gpsTrackerProvider);
    final theme = Theme.of(context);

    final polygonLatLngs = gpsState.capturedPoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    final initialCenter = gpsState.currentPosition != null
        ? LatLng(
            gpsState.currentPosition!.latitude,
            gpsState.currentPosition!.longitude,
          )
        : polygonLatLngs.isNotEmpty
            ? polygonLatLngs.last
            : const LatLng(-3.3869, 36.6830);

    return Stack(
      children: [
        FlutterMap(
          mapController: _internalMapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 17.0,
            maxZoom: 19.0,
            minZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.tcb.field_officer',
            ),
            if (polygonLatLngs.length >= 3)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: polygonLatLngs,
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    borderColor: theme.colorScheme.primary,
                    borderStrokeWidth: 3.0,
                    isFilled: true,
                  ),
                ],
              ),
            if (polygonLatLngs.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polygonLatLngs,
                    color: theme.colorScheme.primary,
                    strokeWidth: 3.0,
                  ),
                ],
              ),
            MarkerLayer(
              markers: polygonLatLngs.asMap().entries.map((entry) {
                final idx = entry.key;
                final point = entry.value;

                return Marker(
                  point: point,
                  width: 32,
                  height: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${idx + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Points Recorded: ${polygonLatLngs.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Area: ${gpsState.calculatedAcreage} Acres',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (gpsState.capturedPoints.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(gpsTrackerProvider.notifier).removeLastPoint();
                    },
                    icon: const Icon(Icons.undo, size: 18),
                    label: const Text('Undo'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
