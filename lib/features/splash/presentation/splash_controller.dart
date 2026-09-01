import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_provider.dart';

enum SplashDestination {
  login,
  home,
}

class SplashController extends StateNotifier<AsyncValue<SplashDestination>> {
  final Ref _ref;

  SplashController(this._ref) : super(const AsyncValue.loading()) {
    _resolveDestination();
  }

  Future<void> _resolveDestination() async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(authProvider.notifier).ready;

      final isLoggedIn = _ref.read(authProvider).isAuthenticated;
      state = AsyncValue.data(
        isLoggedIn ? SplashDestination.home : SplashDestination.login,
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> retry() async {
    await _resolveDestination();
  }
}

final splashControllerProvider = StateNotifierProvider.autoDispose<
    SplashController, AsyncValue<SplashDestination>>((ref) {
  return SplashController(ref);
});
