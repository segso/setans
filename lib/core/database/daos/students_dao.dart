import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/students_table.dart';

part 'students_dao.g.dart';

@DriftAccessor(tables: [Students])
class StudentsDao extends DatabaseAccessor<AppDatabase> with _$StudentsDaoMixin {
  StudentsDao(super.db);

  Future<List<Student>> getAll() => select(students).get();

  Future<Student?> getById(int id) =>
      (select(students)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<List<Student>> search(String query) {
    final pattern = '%$query%';
    return (select(students)
          ..where(
            (s) =>
                s.id.cast<String>().like(pattern) |
                s.name.like(pattern) |
                s.major.like(pattern) |
                s.shift.like(pattern),
          ))
        .get();
  }

  Future<void> insert(StudentsCompanion student) =>
      into(students).insert(student);

  Future<void> updateStudent(StudentsCompanion student) =>
      update(students).replace(student);

  Future<void> deleteStudent(int id) =>
      (delete(students)..where((s) => s.id.equals(id))).go();
}
