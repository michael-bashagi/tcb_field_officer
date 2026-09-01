class AgriculturalZone {
  final String uid;
  final String name;

  const AgriculturalZone({required this.uid, required this.name});

  factory AgriculturalZone.fromJson(Map<String, dynamic> json) {
    return AgriculturalZone(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AgriculturalZone && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
