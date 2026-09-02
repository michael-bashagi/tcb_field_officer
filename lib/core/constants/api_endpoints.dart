class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.1.1.228:9090';
  static const String graphql = '/graphql';

  static const String principal = '/principal';

  static const String logout = '/users/logout';

  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration connectionTimeout = Duration(seconds: 20);
}
