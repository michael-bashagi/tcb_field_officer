import 'dart:convert';

class BoundaryPoint {
  final double latitude;
  final double longitude;

  final double altitude;

  const BoundaryPoint({
    required this.latitude,
    required this.longitude,
    this.altitude = 0.0,
  });

  factory BoundaryPoint.fromJson(Map<String, dynamic> json) {
    return BoundaryPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
      };
}

class Farm {
  static const double acresPerHectare = 2.47105;

  static const int minRingPositions = 4;

  final String? uid;
  final double sizeInAcres;
  final double latitude;
  final double longitude;
  final String locationFromGeospatial;
  final List<BoundaryPoint> boundaryPoints;

  final String? farmerUid;
  final String? agriculturalZoneUid;
  final String? agriculturalZoneName;
  final String? subWardUid;

  const Farm({
    this.uid,
    required this.sizeInAcres,
    required this.latitude,
    required this.longitude,
    required this.locationFromGeospatial,
    this.boundaryPoints = const [],
    this.farmerUid,
    this.agriculturalZoneUid,
    this.agriculturalZoneName,
    this.subWardUid,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    final zone = json['agriculturalZone'] as Map<String, dynamic>?;
    final subWard = json['subWard'] as Map<String, dynamic>?;
    return Farm(
      uid: json['uid'] as String?,
      sizeInAcres:
          ((json['size'] as num?)?.toDouble() ?? 0.0) * acresPerHectare,
      latitude: 0.0,
      longitude: 0.0,
      locationFromGeospatial: json['name'] as String? ?? 'Unknown Location',
      agriculturalZoneUid: zone?['uid'] as String?,
      agriculturalZoneName: zone?['name'] as String?,
      subWardUid: subWard?['uid'] as String?,
    );
  }

  String? toGeoJson() {
    if (boundaryPoints.length < minRingPositions - 1) return null;

    final ring = boundaryPoints
        .map((p) => [p.longitude, p.latitude, p.altitude])
        .toList();
    final first = ring.first;
    final last = ring.last;
    if (first[0] != last[0] || first[1] != last[1]) {
      ring.add(first);
    }
    if (ring.length < minRingPositions) return null;

    return jsonEncode({
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': const {},
          'geometry': {
            'type': 'Polygon',
            'coordinates': [ring],
          },
        },
      ],
    });
  }

  Map<String, dynamic> toFarmDtoInput() {
    final geoJson = toGeoJson();
    return {
      if (uid != null) 'uid': uid,
      'name': locationFromGeospatial,
      if (geoJson != null) 'geoJson': geoJson,
      'agriculturalZoneUid': agriculturalZoneUid,
      'subWardUid': subWardUid,
    };
  }

  Farm copyWith({
    String? uid,
    String? farmerUid,
    String? agriculturalZoneUid,
    String? agriculturalZoneName,
    String? subWardUid,
  }) {
    return Farm(
      uid: uid ?? this.uid,
      sizeInAcres: sizeInAcres,
      latitude: latitude,
      longitude: longitude,
      locationFromGeospatial: locationFromGeospatial,
      boundaryPoints: boundaryPoints,
      farmerUid: farmerUid ?? this.farmerUid,
      agriculturalZoneUid: agriculturalZoneUid ?? this.agriculturalZoneUid,
      agriculturalZoneName: agriculturalZoneName ?? this.agriculturalZoneName,
      subWardUid: subWardUid ?? this.subWardUid,
    );
  }
}
