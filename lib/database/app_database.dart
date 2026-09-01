import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/farmers_table.dart';
import 'tables/farms_table.dart';
import 'tables/bill_cache_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [FarmersTable, FarmsTable, BillCacheTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<FarmersTableData>> getAllFarmers() => select(farmersTable).get();

  Future<List<FarmersTableData>> searchFarmers(String query) {
    return (select(farmersTable)
          ..where((tbl) =>
              tbl.firstName.like('%$query%') |
              tbl.lastName.like('%$query%') |
              tbl.phoneNumber.like('%$query%')))
        .get();
  }

  Future<void> cacheFarmers(List<FarmersTableCompanion> farmers) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(farmersTable, farmers);
    });
  }

  Future<List<FarmsTableData>> getAllFarms() => select(farmsTable).get();

  Future<void> cacheFarms(List<FarmsTableCompanion> farms) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(farmsTable, farms);
    });
  }

  Future<void> cacheBill(BillCacheTableCompanion bill) {
    return into(billCacheTable).insertOnConflictUpdate(bill);
  }

  Future<BillCacheTableData?> getBillForFarmer(String farmerUid) {
    return (select(billCacheTable)
          ..where((tbl) => tbl.farmerUid.equals(farmerUid)))
        .getSingleOrNull();
  }

  Future<List<BillCacheTableData>> getAllCachedBills() =>
      select(billCacheTable).get();

  Future<void> clearAllCache() async {
    await delete(farmersTable).go();
    await delete(farmsTable).go();
    await delete(billCacheTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tcb_field_officer.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
