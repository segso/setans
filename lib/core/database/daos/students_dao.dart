import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/students_table.dart';
import '../tables/assistances_table.dart';

part 'students_dao.g.dart';

@DriftAccessor(tables: [Students, Assistances])
class StudentsDao extends DatabaseAccessor<AppDatabase> with _$StudentsDaoMixin {
  StudentsDao(super.db);

  Future<List<Student>> getAll() => select(students).get();

  Future<Student?> getById(int id) =>
      (select(students)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<List<Student>> search(String query) async {
    final tokens = _normalize(query)
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return getAll();

    final all = await select(students).get();
    return all.where((s) {
      final text = _normalize(
          '${s.id} ${s.name} ${s.major} ${s.shift}');
      return tokens.every((t) => text.contains(t));
    }).toList();
  }

  String _normalize(String s) =>
      s.toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ü', 'u').replaceAll('ñ', 'n');

  Future<void> insert(StudentsCompanion student) =>
      into(students).insert(student);

  Future<void> updateStudent(StudentsCompanion student) =>
      update(students).replace(student);

  Future<void> deleteStudent(int id) async {
    await (delete(assistances)..where((a) => a.studentId.equals(id))).go();
    await (delete(students)..where((s) => s.id.equals(id))).go();
  }
}
