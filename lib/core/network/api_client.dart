import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';
import '../constants/oauth_config.dart';

const String kAccessTokenStorageKey = 'oauth_access_token';
const String kRefreshTokenStorageKey = 'oauth_refresh_token';
const String kExpiresAtStorageKey = 'oauth_expires_at';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<String?>? _pendingRefresh;

  ApiClient({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? Dio(),
        _storage = storage ?? const FlutterSecureStorage() {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: ApiEndpoints.connectionTimeout,
      receiveTimeout: ApiEndpoints.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _validAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get client => _dio;

  /// Returns the current access token, refreshing it first if it has
  /// expired. Concurrent callers share a single in-flight refresh so a
  /// burst of requests around expiry doesn't spend the refresh token
  /// more than once.
  Future<String?> _validAccessToken() async {
    final expiresAtRaw = await _storage.read(key: kExpiresAtStorageKey);
    final expiresAt =
        expiresAtRaw != null ? DateTime.tryParse(expiresAtRaw) : null;
    final isExpired = expiresAt == null || DateTime.now().isAfter(expiresAt);

    if (isExpired) {
      debugPrint(
          '[auth] token expired (expiresAt=$expiresAt, now=${DateTime.now()}), refreshing...');
      final sw = Stopwatch()..start();
      final refreshed = await (_pendingRefresh ??= _refreshAccessToken());
      debugPrint(
          '[auth] refresh finished in ${sw.elapsedMilliseconds}ms, success=${refreshed != null}');
      if (refreshed != null) return refreshed;
    }
    return _storage.read(key: kAccessTokenStorageKey);
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: kRefreshTokenStorageKey);
      if (refreshToken == null) return null;

      final response = await Dio().post(
        OAuthConfig.tokenUrl,
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': OAuthConfig.clientId,
          'client_secret': OAuthConfig.clientSecret,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken = data['refresh_token'] as String? ?? refreshToken;
      final expiresIn = data['expires_in'] as int? ?? 3600;
      final newExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
      debugPrint('[auth] new token expires_in=$expiresIn -> $newExpiresAt');

      await _storage.write(key: kAccessTokenStorageKey, value: newAccessToken);
      await _storage.write(
          key: kRefreshTokenStorageKey, value: newRefreshToken);
      await _storage.write(
          key: kExpiresAtStorageKey, value: newExpiresAt.toIso8601String());

      return newAccessToken;
    } catch (e) {
      debugPrint('[auth] refresh failed: $e');
      return null;
    } finally {
      _pendingRefresh = null;
    }
  }
}
