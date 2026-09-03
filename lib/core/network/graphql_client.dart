import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../constants/api_endpoints.dart';
import 'api_client.dart';

class GraphQLException implements Exception {
  final String message;
  const GraphQLException(this.message);

  @override
  String toString() => message;
}

/// Turns any caught error into a short, plain-language message that is
/// safe to show a field officer. GraphQLException messages are already
/// authored to be readable, so they pass straight through; anything else
/// falls back to [fallback] instead of leaking implementation detail.
String userFacingErrorMessage(Object error, [String? fallback]) {
  if (error is GraphQLException) return error.message;
  return fallback ??
      'Something went wrong. Please check your connection and try again.';
}

class GraphQLClient {
  final Dio _dio;

  GraphQLClient(ApiClient apiClient) : _dio = apiClient.client;

  Future<Map<String, dynamic>> request(
    String document, {
    Map<String, dynamic>? variables,
  }) async {
    final operation = document.trim().split('\n').first.trim();
    final sw = Stopwatch()..start();
    late final Response response;
    try {
      response = await _dio.post(
        ApiEndpoints.graphql,
        data: {
          'query': document,
          if (variables != null) 'variables': variables,
        },
      );
    } on DioException catch (e) {
      debugPrint(
          '[graphql] $operation failed after ${sw.elapsedMilliseconds}ms: ${e.message}');
      throw GraphQLException(_messageForDioException(e));
    }
    debugPrint('[graphql] $operation completed in ${sw.elapsedMilliseconds}ms');

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const GraphQLException('Unexpected response from server.');
    }

    final errors = body['errors'] as List<dynamic>?;
    if (errors != null && errors.isNotEmpty) {
      final message = errors
          .map((e) => (e as Map<String, dynamic>)['message']?.toString())
          .whereType<String>()
          .join('; ');
      debugPrint('GraphQL error: $message');
      throw const GraphQLException(
        'Something went wrong while contacting the server. Please try again, '
        'or contact your supervisor if this keeps happening.',
      );
    }

    return (body['data'] as Map<String, dynamic>?) ?? const {};
  }

  Map<String, dynamic>? unwrapEnvelope(
      Map<String, dynamic> data, String field) {
    final envelope = data[field] as Map<String, dynamic>?;
    if (envelope == null) return null;

    final status = envelope['status'] as bool? ?? true;
    if (!status) {
      throw GraphQLException(
          envelope['message'] as String? ?? 'Request failed.');
    }
    return envelope['data'] as Map<String, dynamic>?;
  }

  String _messageForDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection available. Please connect to a network.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) {
          return 'Session expired or unauthorized. Please log in again.';
        }
        if (status == 403) {
          return 'You do not have permission to perform this action.';
        }
        return 'Server responded with error code: $status';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
