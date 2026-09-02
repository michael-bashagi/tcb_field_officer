import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/graphql_client.dart';
import '../../core/network/network_providers.dart';
import '../../database/app_database.dart';
import '../../main.dart';
import '../domain/farm.dart';
import '../domain/farmer_request.dart';
import '../domain/named_ref.dart';

const String _getCottonDistrictsQuery = r'''
  query GetCottonDistricts($pageableParam: PageableParamInput) {
    getDistrictsPageable(active: true, pageableParam: $pageableParam) {
      content { uid name cottonDistrict }
    }
  }
''';

const String _getRegionsQuery = r'''
  query GetRegions($pageableParam: PageableParamInput) {
    getRegionsPageable(active: true, pageableParam: $pageableParam) {
      content { uid name }
    }
  }
''';

const String _getDistrictsQuery = r'''
  query GetDistricts($regionUid: String, $pageableParam: PageableParamInput) {
    getDistrictsPageable(active: true, regionUid: $regionUid, pageableParam: $pageableParam) {
      content { uid name }
    }
  }
''';

const String _getWardsQuery = r'''
  query GetWards($districtUid: String, $pageableParam: PageableParamInput) {
    getWardsPageable(active: true, districtUid: $districtUid, pageableParam: $pageableParam) {
      content { uid name }
    }
  }
''';

const String _getSubWardsQuery = r'''
  query GetSubWards($wardUid: String, $pageableParam: PageableParamInput) {
    getSubWardsPageable(active: true, wardUid: $wardUid, pageableParam: $pageableParam) {
      content { uid name }
    }
  }
''';

const String _createFarmerMutation = r'''
  mutation CreateOrUpdateFarmer($dto: FarmerDtoInput) {
    createOrUpdateFarmer(dto: $dto) {
      status
      message
      data { uid name email phone }
    }
  }
''';

const String _createFarmMutation = r'''
  mutation CreateOrUpdateFarm($dto: FarmDtoInput) {
    createOrUpdateFarm(dto: $dto) {
      status
      message
      data {
        uid
        name
        size
        notes
        active
      }
    }
  }
''';

const String _createSeasonFarmFarmerMutation = r'''
  mutation CreateOrUpdateSeasonFarmFarmer($dto: SeasonFarmFarmerDtoInput) {
    createOrUpdateSeasonFarmFarmer(dto: $dto) {
      status
      message
      data { uid }
    }
  }
''';

const String _prepareCultivationBillMutation = r'''
  mutation PrepareCultivationBill($seasonFarmFarmerUid: String) {
    prepareCultivationBill(seasonFarmFarmerUid: $seasonFarmFarmerUid) {
      status
      message
      data {
        uid
        bill { uid controlNumber billAmount }
      }
    }
  }
''';

class RegistrationResult {
  final FarmerRequest farmer;
  final String controlNumber;
  final double amount;

  const RegistrationResult({
    required this.farmer,
    required this.controlNumber,
    required this.amount,
  });
}

class FarmRepository {
  final GraphQLClient _graphQLClient;
  final AppDatabase _database;

  FarmRepository({
    required GraphQLClient graphQLClient,
    required AppDatabase database,
  })  : _graphQLClient = graphQLClient,
        _database = database;

  Future<List<NamedRef>> getCottonDistricts() async {
    final data = await _graphQLClient.request(
      _getCottonDistrictsQuery,
      variables: {
        'pageableParam': {'size': 200},
      },
    );
    final page = data['getDistrictsPageable'] as Map<String, dynamic>?;
    final content = page?['content'] as List<dynamic>? ?? const [];
    return content
        .cast<Map<String, dynamic>>()
        .where((e) => e['cottonDistrict'] == true)
        .map(NamedRef.fromJson)
        .toList();
  }

  Future<List<NamedRef>> getRegions() {
    return _fetchNamedRefs(_getRegionsQuery, 'getRegionsPageable', {});
  }

  Future<List<NamedRef>> getDistricts(String regionUid) {
    return _fetchNamedRefs(
      _getDistrictsQuery,
      'getDistrictsPageable',
      {'regionUid': regionUid},
    );
  }

  Future<List<NamedRef>> getWards(String districtUid) {
    return _fetchNamedRefs(
      _getWardsQuery,
      'getWardsPageable',
      {'districtUid': districtUid},
    );
  }

  Future<List<NamedRef>> getSubWards(String wardUid) {
    return _fetchNamedRefs(
      _getSubWardsQuery,
      'getSubWardsPageable',
      {'wardUid': wardUid},
    );
  }

  Future<List<NamedRef>> _fetchNamedRefs(
    String query,
    String fieldName,
    Map<String, dynamic> extraVariables,
  ) async {
    final data = await _graphQLClient.request(
      query,
      variables: {
        'pageableParam': {'size': 200},
        ...extraVariables,
      },
    );
    final page = data[fieldName] as Map<String, dynamic>?;
    final content = page?['content'] as List<dynamic>? ?? const [];
    return content
        .map((e) => NamedRef.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FarmerRequest> registerFarmerWithFarm({
    required FarmerRequest farmer,
    required String agriculturalZoneUid,
    required String subWardUid,
  }) async {
    final farmerUid = await _createFarmer(farmer);

    final farmWithRefs = farmer.farm.copyWith(
      farmerUid: farmerUid,
      agriculturalZoneUid: agriculturalZoneUid,
      subWardUid: subWardUid,
    );
    final createdFarm = await _createFarm(farmWithRefs);
    final farmUid = createdFarm.uid!;

    final seasonFarmFarmerUid =
        await _linkFarmerToFarm(farmerUid: farmerUid, farmUid: farmUid);

    return farmer.copyWith(
      uid: farmerUid,
      farm: createdFarm,
      seasonFarmFarmerUid: seasonFarmFarmerUid,
    );
  }

  Future<RegistrationResult> generateControlNumber(FarmerRequest farmer) async {
    final seasonFarmFarmerUid = farmer.seasonFarmFarmerUid;
    final farmerUid = farmer.uid;
    if (seasonFarmFarmerUid == null || farmerUid == null) {
      throw const GraphQLException(
          'Farmer must be registered before generating a control number.');
    }

    final data = await _graphQLClient.request(
      _prepareCultivationBillMutation,
      variables: {'seasonFarmFarmerUid': seasonFarmFarmerUid},
    );
    final result =
        _graphQLClient.unwrapEnvelope(data, 'prepareCultivationBill');
    final bill = result?['bill'] as Map<String, dynamic>?;
    if (bill == null) {
      throw const GraphQLException(
        'Failed to prepare the cultivation bill — check that a season zone rate is configured for this zone.',
      );
    }
    final controlNumber = bill['controlNumber'] as String? ?? '';
    final amount = (bill['billAmount'] as num?)?.toDouble() ?? 0.0;

    await _database.cacheBill(
      BillCacheTableCompanion.insert(
        farmerUid: farmerUid,
        controlNumber: controlNumber,
        amount: amount,
        generatedAt: DateTime.now(),
        paymentStatus: const Value('PENDING'),
      ),
    );

    return RegistrationResult(
      farmer: farmer.copyWith(controlNumber: controlNumber),
      controlNumber: controlNumber,
      amount: amount,
    );
  }

  Future<String> _linkFarmerToFarm(
      {required String farmerUid, required String farmUid}) async {
    final data = await _graphQLClient.request(
      _createSeasonFarmFarmerMutation,
      variables: {
        'dto': {'farmUid': farmUid, 'farmerUid': farmerUid},
      },
    );
    final result =
        _graphQLClient.unwrapEnvelope(data, 'createOrUpdateSeasonFarmFarmer');
    final uid = result?['uid'] as String?;
    if (uid == null) {
      throw const GraphQLException(
          'Failed to link the farmer to the farm for this season.');
    }
    return uid;
  }

  Future<String> _createFarmer(FarmerRequest farmer) async {
    final data = await _graphQLClient.request(
      _createFarmerMutation,
      variables: {'dto': farmer.toFarmerDtoInput()},
    );
    final result = _graphQLClient.unwrapEnvelope(data, 'createOrUpdateFarmer');
    final uid = result?['uid'] as String?;
    if (uid == null) {
      throw const GraphQLException('Failed to register farmer.');
    }
    return uid;
  }

  Future<Farm> _createFarm(Farm farm) async {
    final data = await _graphQLClient.request(
      _createFarmMutation,
      variables: {'dto': farm.toFarmDtoInput()},
    );
    final result = _graphQLClient.unwrapEnvelope(data, 'createOrUpdateFarm');
    if (result == null) {
      throw const GraphQLException('Failed to save the demarcated farm.');
    }
    return farm.copyWith(uid: result['uid'] as String?);
  }

  Future<BillCacheTableData?> getCachedBill(String farmerUid) {
    return _database.getBillForFarmer(farmerUid);
  }
}

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  return FarmRepository(
    graphQLClient: ref.watch(graphQLClientProvider),
    database: ref.watch(databaseProvider),
  );
});

final cottonDistrictsProvider = FutureProvider<List<NamedRef>>((ref) {
  return ref.watch(farmRepositoryProvider).getCottonDistricts();
});

final regionsProvider = FutureProvider<List<NamedRef>>((ref) {
  return ref.watch(farmRepositoryProvider).getRegions();
});

final districtsProvider =
    FutureProvider.family<List<NamedRef>, String>((ref, regionUid) {
  return ref.watch(farmRepositoryProvider).getDistricts(regionUid);
});

final wardsProvider =
    FutureProvider.family<List<NamedRef>, String>((ref, districtUid) {
  return ref.watch(farmRepositoryProvider).getWards(districtUid);
});

final subWardsProvider =
    FutureProvider.family<List<NamedRef>, String>((ref, wardUid) {
  return ref.watch(farmRepositoryProvider).getSubWards(wardUid);
});
