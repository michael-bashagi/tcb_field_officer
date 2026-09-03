import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/api_client.dart';
import '../domain/field_officer.dart';
import 'oauth_client.dart';

class AuthLocalStorage {
  final FlutterSecureStorage _storage;

  AuthLocalStorage(this._storage);

  static const String _keyOfficer = 'cached_field_officer';

  Future<void> saveTokens(OAuthTokens tokens) async {
    await _storage.write(
        key: kAccessTokenStorageKey, value: tokens.accessToken);
    if (tokens.refreshToken != null) {
      await _storage.write(
          key: kRefreshTokenStorageKey, value: tokens.refreshToken);
    }
    await _storage.write(
        key: kExpiresAtStorageKey, value: tokens.expiresAt.toIso8601String());
  }

  Future<void> saveOfficer(FieldOfficer officer) async {
    await _storage.write(key: _keyOfficer, value: jsonEncode(officer.toJson()));
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: kAccessTokenStorageKey);

  Future<String?> getRefreshToken() =>
      _storage.read(key: kRefreshTokenStorageKey);

  Future<bool> isAccessTokenExpired() async {
    final raw = await _storage.read(key: kExpiresAtStorageKey);
    if (raw == null) return true;
    final expiresAt = DateTime.tryParse(raw);
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }

  Future<FieldOfficer?> getSavedOfficer() async {
    final officerJson = await _storage.read(key: _keyOfficer);
    if (officerJson == null) return null;
    try {
      return FieldOfficer.fromJson(
          jsonDecode(officerJson) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: kAccessTokenStorageKey);
    await _storage.delete(key: kRefreshTokenStorageKey);
    await _storage.delete(key: kExpiresAtStorageKey);
    await _storage.delete(key: _keyOfficer);
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return AuthLocalStorage(ref.watch(secureStorageProvider));
});
