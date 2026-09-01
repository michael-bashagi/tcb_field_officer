import 'package:drift/drift.dart';

class FarmsTable extends Table {
  TextColumn get id => text()();
  TextColumn get location => text()();
  RealColumn get acreage => real()();

  TextColumn get polygonCoordinatesJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
