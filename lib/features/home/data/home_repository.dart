import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/graphql_client.dart';
import '../../../core/network/network_providers.dart';
import '../../../farmer_registration/domain/farmer_request.dart';
import '../domain/home_metrics.dart';

const String _mySeasonFarmFarmersQuery = r'''
  query GetMySeasonFarmFarmers($active: Boolean!, $pageableParam: PageableParamInput) {
    getMySeasonFarmFarmersPageable(active: $active, pageableParam: $pageableParam) {
      content {
        uid
        farm {
          uid
          name
          size
          agriculturalZone { uid name }
          subWard { uid name }
        }
        farmer { uid name email phone }
        createdBy { uid fullName }
      }
    }
  }
''';

abstract class HomeRepository {
  Future<HomeMetrics> getDashboardMetrics();
  Future<List<FarmerRequest>> getMyFarmers();
}

class HomeRepositoryImpl implements HomeRepository {
  final GraphQLClient _graphQLClient;

  HomeRepositoryImpl(this._graphQLClient);

  @override
  Future<HomeMetrics> getDashboardMetrics() async {
    final myFarmers = await getMyFarmers();
    final totalAcreage = myFarmers.fold<double>(
      0.0,
      (sum, farmer) => sum + farmer.farm.sizeInAcres,
    );

    return HomeMetrics(
      totalFarmersRegistered: myFarmers.length,
      totalMappedAcreage: double.parse(totalAcreage.toStringAsFixed(2)),
    );
  }

  @override
  Future<List<FarmerRequest>> getMyFarmers() async {
    final data = await _graphQLClient.request(
      _mySeasonFarmFarmersQuery,
      variables: {
        'active': true,
        'pageableParam': {'size': 500},
      },
    );
    final page =
        data['getMySeasonFarmFarmersPageable'] as Map<String, dynamic>?;
    final content = page?['content'] as List<dynamic>? ?? const [];

    return content
        .cast<Map<String, dynamic>>()
        .map(FarmerRequest.fromSeasonFarmFarmerJson)
        .toList()
        .reversed
        .toList();
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(graphQLClientProvider));
});
