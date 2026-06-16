import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/students_table.dart';
import 'tables/assistances_table.dart';
import 'daos/students_dao.dart';
import 'daos/assistances_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Students, Assistances])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  late final StudentsDao studentsDao = StudentsDao(this);
  late final AssistancesDao assistancesDao = AssistancesDao(this);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    await Directory(dir.path).create(recursive: true);
    final file = File(p.join(dir.path, 'setans.db'));
    return NativeDatabase(file);
  });
}
