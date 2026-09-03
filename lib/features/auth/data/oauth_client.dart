import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../core/constants/oauth_config.dart';
import '../../../core/network/pkce.dart';

class OAuthTokens {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  const OAuthTokens({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });

  factory OAuthTokens.fromResponse(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int? ?? 3600;
    return OAuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }
}

class OAuthException implements Exception {
  final String message;
  const OAuthException(this.message);

  @override
  String toString() => message;
}

class OAuthClient {
  final Dio _dio;

  OAuthClient({Dio? dio}) : _dio = dio ?? Dio();

  Future<OAuthTokens> login() async {
    final pkce = PkcePair.generate();
    final state = generateOAuthState();

    final authorizeUri = Uri.parse(OAuthConfig.authorizeUrl).replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': OAuthConfig.clientId,
        'redirect_uri': OAuthConfig.redirectUri,
        'scope': OAuthConfig.scope,
        'state': state,
        'code_challenge': pkce.codeChallenge,
        'code_challenge_method': OAuthConfig.codeChallengeMethod,
      },
    );

    final String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: authorizeUri.toString(),
        callbackUrlScheme: OAuthConfig.callbackUrlScheme,
      );
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        throw const OAuthException('Login was cancelled.');
      }
      debugPrint('OAuth authorize failed: $e\nRequest sent: $authorizeUri');
      throw const OAuthException(
        'Could not open the sign-in page. Please check your connection and try again.',
      );
    } catch (e) {
      debugPrint('OAuth authorize failed: $e\nRequest sent: $authorizeUri');
      throw const OAuthException(
        'Could not open the sign-in page. Please check your connection and try again.',
      );
    }

    final callbackUri = Uri.parse(result);

    final error = callbackUri.queryParameters['error'];
    if (error != null) {
      final description =
          callbackUri.queryParameters['error_description'] ?? error;
      debugPrint(
          'OAuth sign-in returned an error: $description\nFull redirect: $result');
      throw const OAuthException(
          'Sign-in could not be completed. Please try again.');
    }

    if (callbackUri.queryParameters['state'] != state) {
      debugPrint('OAuth state mismatch. Full redirect: $result');
      throw const OAuthException(
        'Login response failed security verification. Please try again.',
      );
    }

    final code = callbackUri.queryParameters['code'];
    if (code == null) {
      debugPrint('OAuth redirect missing authorization code: $result');
      throw const OAuthException(
        'Sign-in could not be completed. Please try again.',
      );
    }

    return _exchange({
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': OAuthConfig.redirectUri,
      'client_id': OAuthConfig.clientId,
      'code_verifier': pkce.codeVerifier,
    });
  }

  Future<OAuthTokens> loginWithPassword({
    required String username,
    required String password,
  }) {
    return _exchange({
      'grant_type': 'password',
      'username': username,
      'password': password,
      'client_id': OAuthConfig.clientId,
      'client_secret': OAuthConfig.clientSecret,
      'scope': OAuthConfig.scope,
    });
  }

  Future<OAuthTokens> refresh(String refreshToken) {
    return _exchange({
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'client_id': OAuthConfig.clientId,
      'client_secret': OAuthConfig.clientSecret,
    });
  }

  Future<OAuthTokens> _exchange(Map<String, dynamic> formData) async {
    try {
      final response = await _dio.post(
        OAuthConfig.tokenUrl,
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return OAuthTokens.fromResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final message =
          (data is Map) ? (data['error_description'] ?? data['error']) : null;
      debugPrint(
          'OAuth token exchange failed: HTTP $status POST ${OAuthConfig.tokenUrl} '
          'body=$formData response=$data');
      throw OAuthException(
        message is String && message.isNotEmpty
            ? message
            : 'Failed to sign in. Please check your username and password and try again.',
      );
    }
  }
}
