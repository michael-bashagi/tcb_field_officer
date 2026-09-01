class NamedRef {
  final String uid;
  final String name;

  const NamedRef({required this.uid, required this.name});

  factory NamedRef.fromJson(Map<String, dynamic> json) {
    return NamedRef(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NamedRef && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
