import 'package:drift/drift.dart';
import 'farms_table.dart';

class FarmersTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get middleName => text().nullable()();
  TextColumn get lastName => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get registeredByOfficer => text()();
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('PENDING'))();
  TextColumn get controlNumber => text().nullable()();

  TextColumn get farmId => text().references(FarmsTable, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
