// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_dao.dart';

// ignore_for_file: type=lint
mixin _$StudentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudentsTable get students => attachedDatabase.students;
  StudentsDaoManager get managers => StudentsDaoManager(this);
}

class StudentsDaoManager {
  final _$StudentsDaoMixin _db;
  StudentsDaoManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
}
