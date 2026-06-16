import 'package:drift/drift.dart';

class Students extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get major => text()();
  TextColumn get shift => text()();
  TextColumn get createdAt => text()();
}
