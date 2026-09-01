import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'graphql_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  return GraphQLClient(ref.watch(apiClientProvider));
});
