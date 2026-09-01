import 'api_endpoints.dart';

class OAuthConfig {
  OAuthConfig._();

  static const String authorizeUrl = '${ApiEndpoints.baseUrl}/oauth2/authorize';
  static const String tokenUrl = '${ApiEndpoints.baseUrl}/oauth2/token';

  static const String clientId = 'ttu';
  static const String clientSecret = 'ttu@2026';

  static const String scope = 'read write';
  static const String codeChallengeMethod = 'S256';

  static const String callbackUrlScheme = 'ttumobile';
  static const String redirectUri = 'ttumobile://oauth/callback';

  static const bool useNativeLoginForm = true;
}
