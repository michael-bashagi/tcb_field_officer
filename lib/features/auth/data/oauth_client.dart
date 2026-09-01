import 'package:dio/dio.dart';
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
      throw OAuthException(
        '${e.message ?? 'Failed to open the sign-in page.'}\n\nRequest sent: $authorizeUri',
      );
    } catch (e) {
      throw OAuthException(
          'Failed to open the sign-in page: $e\n\nRequest sent: $authorizeUri');
    }

    final callbackUri = Uri.parse(result);

    final error = callbackUri.queryParameters['error'];
    if (error != null) {
      final description =
          callbackUri.queryParameters['error_description'] ?? error;
      throw OAuthException(
        '$description\n\nRequest sent: $authorizeUri\n\nFull redirect: $result',
      );
    }

    if (callbackUri.queryParameters['state'] != state) {
      throw OAuthException(
        'Login response failed security verification. Please try again.\n\n'
        'Request sent: $authorizeUri\n\nFull redirect: $result',
      );
    }

    final code = callbackUri.queryParameters['code'];
    if (code == null) {
      throw OAuthException(
        'Login did not return an authorization code.\n\n'
        'Request sent: $authorizeUri\n\nFull redirect: $result',
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
      throw OAuthException(
        '${message ?? 'Failed to sign in.'}\n\n'
        'HTTP $status\n'
        'POST ${OAuthConfig.tokenUrl}\n'
        'Body sent: $formData\n'
        'Response: $data',
      );
    }
  }
}
