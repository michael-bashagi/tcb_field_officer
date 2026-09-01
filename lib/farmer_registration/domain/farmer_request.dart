import 'farm.dart';

class FarmerRequest {
  final String? uid;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String registeredByFieldOfficer;
  final String? controlNumber;
  final String paymentStatus;
  final Farm farm;

  final String? seasonFarmFarmerUid;

  const FarmerRequest({
    this.uid,
    required this.firstName,
    this.middleName = '',
    required this.lastName,
    required this.phoneNumber,
    this.email,
    this.registeredByFieldOfficer = '',
    this.controlNumber,
    this.paymentStatus = 'PENDING',
    required this.farm,
    this.seasonFarmFarmerUid,
  });

  String get fullName => middleName.isEmpty
      ? '$firstName $lastName'.trim()
      : '$firstName $middleName $lastName'.trim();

  factory FarmerRequest.fromSeasonFarmFarmerJson(Map<String, dynamic> json) {
    final farmerJson = json['farmer'] as Map<String, dynamic>? ?? const {};
    final farmJson = json['farm'] as Map<String, dynamic>? ?? const {};
    final createdBy = json['createdBy'] as Map<String, dynamic>?;
    return FarmerRequest(
      uid: farmerJson['uid'] as String?,
      firstName: farmerJson['name'] as String? ?? '',
      lastName: '',
      phoneNumber: farmerJson['phone'] as String? ?? '',
      email: farmerJson['email'] as String?,
      registeredByFieldOfficer: createdBy?['fullName'] as String? ?? '',
      farm: Farm.fromJson(farmJson),
      seasonFarmFarmerUid: json['uid'] as String?,
    );
  }

  Map<String, dynamic> toFarmerDtoInput() => {
        if (uid != null) 'uid': uid,
        'name': fullName,
        if (email != null && email!.isNotEmpty) 'email': email,
        'phone': phoneNumber,
      };

  FarmerRequest copyWith({
    String? uid,
    Farm? farm,
    String? controlNumber,
    String? paymentStatus,
    String? seasonFarmFarmerUid,
  }) {
    return FarmerRequest(
      uid: uid ?? this.uid,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
      registeredByFieldOfficer: registeredByFieldOfficer,
      controlNumber: controlNumber ?? this.controlNumber,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      farm: farm ?? this.farm,
      seasonFarmFarmerUid: seasonFarmFarmerUid ?? this.seasonFarmFarmerUid,
    );
  }
}
