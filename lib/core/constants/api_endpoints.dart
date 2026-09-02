class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://169.58.109.40';
  static const String graphql = '/graphql';

  static const String principal = '/principal';

  static const String logout = '/users/logout';

  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration connectionTimeout = Duration(seconds: 20);
}
