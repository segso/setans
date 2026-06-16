import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/assistances_table.dart';

part 'assistances_dao.g.dart';

@DriftAccessor(tables: [Assistances])
class AssistancesDao extends DatabaseAccessor<AppDatabase>
    with _$AssistancesDaoMixin {
  AssistancesDao(super.db);

  Future<List<Assistance>> getByDate(String date) =>
      (select(assistances)..where((a) => a.date.equals(date))).get();

  Future<List<Assistance>> getByStudent(int studentId) =>
      (select(assistances)..where((a) => a.studentId.equals(studentId))).get();

  Future<List<Assistance>> getAll() => select(assistances).get();

  Future<List<String>> getDatesWithRegistries() {
    return (selectOnly(assistances)
          ..addColumns([assistances.date])
          ..groupBy([assistances.date])
          ..orderBy([OrderingTerm.asc(assistances.date)]))
        .map((row) => row.read(assistances.date)!)
        .get();
  }

  Future<void> upsert(AssistancesCompanion assistance) =>
      into(assistances).insertOnConflictUpdate(assistance);

  Future<void> deleteByDate(String date) =>
      (delete(assistances)..where((a) => a.date.equals(date))).go();
}
