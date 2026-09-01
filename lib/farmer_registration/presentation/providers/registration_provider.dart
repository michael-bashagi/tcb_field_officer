import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/farm.dart';
import '../../domain/farmer_request.dart';

class RegistrationState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  final String firstName;
  final String middleName;
  final String lastName;
  final String phoneNumber;

  final Farm? selectedFarm;

  const RegistrationState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.selectedFarm,
  });

  RegistrationState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? firstName,
    String? middleName,
    String? lastName,
    String? phoneNumber,
    Farm? selectedFarm,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedFarm: selectedFarm ?? this.selectedFarm,
    );
  }
}

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(const RegistrationState());

  void updateFarmerDetails({
    String? firstName,
    String? middleName,
    String? lastName,
    String? phoneNumber,
  }) {
    state = state.copyWith(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }

  void selectFarm(Farm farm) {
    state = state.copyWith(selectedFarm: farm);
  }

  FarmerRequest? buildRequest({required String fieldOfficerName}) {
    if (state.selectedFarm == null ||
        state.firstName.isEmpty ||
        state.lastName.isEmpty ||
        state.phoneNumber.isEmpty) {
      return null;
    }

    return FarmerRequest(
      firstName: state.firstName,
      middleName: state.middleName,
      lastName: state.lastName,
      phoneNumber: state.phoneNumber,
      registeredByFieldOfficer: fieldOfficerName,
      farm: state.selectedFarm!,
    );
  }

  void reset() {
    state = const RegistrationState();
  }
}

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier();
});
