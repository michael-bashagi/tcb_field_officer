import 'package:flutter/foundation.dart';

@immutable
class FieldOfficer {
  final String uid;
  final String username;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fullName;
  final String email;
  final String? phoneNumber;
  final String? nationalId;
  final bool? isStaff;
  final String? departmentUid;
  final String? departmentName;
  final String? departmentCode;
  final List<String> authorities;

  const FieldOfficer({
    required this.uid,
    required this.username,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.nationalId,
    this.isStaff,
    this.departmentUid,
    this.departmentName,
    this.departmentCode,
    this.authorities = const [],
  });

  String get name {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    final combined = [firstName, lastName].whereType<String>().join(' ').trim();
    return combined.isNotEmpty ? combined : username;
  }

  bool hasAuthority(String authority) => authorities.contains(authority);

  factory FieldOfficer.fromJson(Map<String, dynamic> json) {
    return FieldOfficer(
      uid: json['uid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      nationalId: json['nationalId'] as String?,
      isStaff: json['isStaff'] as bool?,
      departmentUid: json['departmentUid'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentCode: json['departmentCode'] as String?,
      authorities:
          (json['authorities'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      if (firstName != null) 'firstName': firstName,
      if (middleName != null) 'middleName': middleName,
      if (lastName != null) 'lastName': lastName,
      if (fullName != null) 'fullName': fullName,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (nationalId != null) 'nationalId': nationalId,
      if (isStaff != null) 'isStaff': isStaff,
      if (departmentUid != null) 'departmentUid': departmentUid,
      if (departmentName != null) 'departmentName': departmentName,
      if (departmentCode != null) 'departmentCode': departmentCode,
      'authorities': authorities,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FieldOfficer && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
