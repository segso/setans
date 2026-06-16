import 'package:drift/drift.dart';
import 'students_table.dart';

class Assistances extends Table {
  IntColumn get studentId => integer().references(Students, #id)();
  TextColumn get date => text()();
  IntColumn get present => integer()();

  @override
  Set<Column> get primaryKey => {studentId, date};
}
