// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistances_dao.dart';

// ignore_for_file: type=lint
mixin _$AssistancesDaoMixin on DatabaseAccessor<AppDatabase> {
  $StudentsTable get students => attachedDatabase.students;
  $AssistancesTable get assistances => attachedDatabase.assistances;
  AssistancesDaoManager get managers => AssistancesDaoManager(this);
}

class AssistancesDaoManager {
  final _$AssistancesDaoMixin _db;
  AssistancesDaoManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db.attachedDatabase, _db.students);
  $$AssistancesTableTableManager get assistances =>
      $$AssistancesTableTableManager(_db.attachedDatabase, _db.assistances);
}
