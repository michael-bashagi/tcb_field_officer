import 'package:drift/drift.dart';

class BillCacheTable extends Table {
  TextColumn get farmerUid => text()();
  TextColumn get controlNumber => text()();
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('PENDING'))();
  RealColumn get amount => real()();
  DateTimeColumn get generatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {farmerUid};
}
