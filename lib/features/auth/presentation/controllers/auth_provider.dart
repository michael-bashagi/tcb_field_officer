import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcb_field_officer/features/auth/data/auth_repository.dart';
import 'package:tcb_field_officer/features/auth/domain/field_officer.dart';

class AuthState {
  final bool isLoading;
  final bool isRestoring;
  final FieldOfficer? officer;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isRestoring = true,
    this.officer,
    this.errorMessage,
  });

  bool get isAuthenticated => officer != null;

  AuthState copyWith({
    bool? isLoading,
    bool? isRestoring,
    FieldOfficer? officer,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      officer: officer ?? this.officer,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  late final Future<void> ready;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    ready = _restoreSession();
  }

  Future<void> _restoreSession() async {
    final officer = await _authRepository.restoreSession();
    state = state.copyWith(officer: officer, isRestoring: false);
  }

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final officer = await _authRepository.login();
      state = state.copyWith(isLoading: false, officer: officer);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> loginWithPassword({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final officer = await _authRepository.loginWithPassword(
        username: username,
        password: password,
      );
      state = state.copyWith(isLoading: false, officer: officer);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authRepository.logout();
    state = const AuthState(isRestoring: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

final currentOfficerProvider = Provider<FieldOfficer?>((ref) {
  return ref.watch(authProvider).officer;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
