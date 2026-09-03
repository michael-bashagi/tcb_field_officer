import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_providers.dart';
import '../domain/field_officer.dart';
import 'auth_local_storage.dart';
import 'oauth_client.dart';

class AuthRepository {
  final OAuthClient _oauthClient;
  final ApiClient _apiClient;
  final AuthLocalStorage _localStorage;

  AuthRepository({
    required OAuthClient oauthClient,
    required ApiClient apiClient,
    required AuthLocalStorage localStorage,
  })  : _oauthClient = oauthClient,
        _apiClient = apiClient,
        _localStorage = localStorage;

  Future<FieldOfficer> login() async {
    final tokens = await _oauthClient.login();
    await _localStorage.saveTokens(tokens);

    final officer = await fetchProfile();
    await _localStorage.saveOfficer(officer);
    return officer;
  }

  Future<FieldOfficer> loginWithPassword({
    required String username,
    required String password,
  }) async {
    final tokens = await _oauthClient.loginWithPassword(
        username: username, password: password);
    await _localStorage.saveTokens(tokens);

    final officer = await fetchProfile();
    await _localStorage.saveOfficer(officer);
    return officer;
  }

  Future<FieldOfficer?> restoreSession() async {
    final sw = Stopwatch()..start();
    final accessToken = await _localStorage.getAccessToken();
    if (accessToken == null) {
      debugPrint('[auth] restoreSession: no saved session');
      return null;
    }

    if (await _localStorage.isAccessTokenExpired()) {
      debugPrint('[auth] restoreSession: token expired, refreshing...');
      final refreshToken = await _localStorage.getRefreshToken();
      if (refreshToken == null) {
        await _localStorage.clearSession();
        return null;
      }
      try {
        final tokens = await _oauthClient.refresh(refreshToken);
        await _localStorage.saveTokens(tokens);
      } catch (e) {
        debugPrint('[auth] restoreSession: refresh failed: $e');
        await _localStorage.clearSession();
        return null;
      }
    }

    try {
      final officer = await fetchProfile();
      await _localStorage.saveOfficer(officer);
      debugPrint(
          '[auth] restoreSession completed in ${sw.elapsedMilliseconds}ms');
      return officer;
    } catch (e) {
      debugPrint(
          '[auth] restoreSession: fetchProfile failed after ${sw.elapsedMilliseconds}ms: $e');
      return _localStorage.getSavedOfficer();
    }
  }

  Future<FieldOfficer> fetchProfile() async {
    final response = await _apiClient.client.get(ApiEndpoints.principal);
    final profile = response.data;
    if (profile is! Map<String, dynamic>) {
      throw StateError('Unexpected /principal response shape.');
    }
    return FieldOfficer.fromJson(profile);
  }

  Future<void> logout() async {
    final accessToken = await _localStorage.getAccessToken();
    final refreshToken = await _localStorage.getRefreshToken();
    try {
      await _apiClient.client.post(
        ApiEndpoints.logout,
        data: {
          'token': accessToken ?? '',
          if (refreshToken != null) 'refresh-token': refreshToken,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
    } catch (_) {}
    await _localStorage.clearSession();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    oauthClient: OAuthClient(),
    apiClient: ref.watch(apiClientProvider),
    localStorage: ref.watch(authLocalStorageProvider),
  );
});
