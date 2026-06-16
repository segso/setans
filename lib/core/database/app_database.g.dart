// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _majorMeta = const VerificationMeta('major');
  @override
  late final GeneratedColumn<String> major = GeneratedColumn<String>(
    'major',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<String> shift = GeneratedColumn<String>(
    'shift',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, major, shift, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('major')) {
      context.handle(
        _majorMeta,
        major.isAcceptableOrUnknown(data['major']!, _majorMeta),
      );
    } else if (isInserting) {
      context.missing(_majorMeta);
    }
    if (data.containsKey('shift')) {
      context.handle(
        _shiftMeta,
        shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      major: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}major'],
      )!,
      shift: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String name;
  final String major;
  final String shift;
  final String createdAt;
  const Student({
    required this.id,
    required this.name,
    required this.major,
    required this.shift,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['major'] = Variable<String>(major);
    map['shift'] = Variable<String>(shift);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      name: Value(name),
      major: Value(major),
      shift: Value(shift),
      createdAt: Value(createdAt),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      major: serializer.fromJson<String>(json['major']),
      shift: serializer.fromJson<String>(json['shift']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'major': serializer.toJson<String>(major),
      'shift': serializer.toJson<String>(shift),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Student copyWith({
    int? id,
    String? name,
    String? major,
    String? shift,
    String? createdAt,
  }) => Student(
    id: id ?? this.id,
    name: name ?? this.name,
    major: major ?? this.major,
    shift: shift ?? this.shift,
    createdAt: createdAt ?? this.createdAt,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      major: data.major.present ? data.major.value : this.major,
      shift: data.shift.present ? data.shift.value : this.shift,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('major: $major, ')
          ..write('shift: $shift, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, major, shift, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.name == this.name &&
          other.major == this.major &&
          other.shift == this.shift &&
          other.createdAt == this.createdAt);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> major;
  final Value<String> shift;
  final Value<String> createdAt;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.major = const Value.absent(),
    this.shift = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String major,
    required String shift,
    required String createdAt,
  }) : name = Value(name),
       major = Value(major),
       shift = Value(shift),
       createdAt = Value(createdAt);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? major,
    Expression<String>? shift,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (major != null) 'major': major,
      if (shift != null) 'shift': shift,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StudentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? major,
    Value<String>? shift,
    Value<String>? createdAt,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      major: major ?? this.major,
      shift: shift ?? this.shift,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (major.present) {
      map['major'] = Variable<String>(major.value);
    }
    if (shift.present) {
      map['shift'] = Variable<String>(shift.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('major: $major, ')
          ..write('shift: $shift, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AssistancesTable extends Assistances
    with TableInfo<$AssistancesTable, Assistance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssistancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presentMeta = const VerificationMeta(
    'present',
  );
  @override
  late final GeneratedColumn<int> present = GeneratedColumn<int>(
    'present',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [studentId, date, present];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assistances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Assistance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('present')) {
      context.handle(
        _presentMeta,
        present.isAcceptableOrUnknown(data['present']!, _presentMeta),
      );
    } else if (isInserting) {
      context.missing(_presentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {studentId, date};
  @override
  Assistance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Assistance(
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}student_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      present: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}present'],
      )!,
    );
  }

  @override
  $AssistancesTable createAlias(String alias) {
    return $AssistancesTable(attachedDatabase, alias);
  }
}

class Assistance extends DataClass implements Insertable<Assistance> {
  final int studentId;
  final String date;
  final int present;
  const Assistance({
    required this.studentId,
    required this.date,
    required this.present,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['student_id'] = Variable<int>(studentId);
    map['date'] = Variable<String>(date);
    map['present'] = Variable<int>(present);
    return map;
  }

  AssistancesCompanion toCompanion(bool nullToAbsent) {
    return AssistancesCompanion(
      studentId: Value(studentId),
      date: Value(date),
      present: Value(present),
    );
  }

  factory Assistance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Assistance(
      studentId: serializer.fromJson<int>(json['studentId']),
      date: serializer.fromJson<String>(json['date']),
      present: serializer.fromJson<int>(json['present']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'studentId': serializer.toJson<int>(studentId),
      'date': serializer.toJson<String>(date),
      'present': serializer.toJson<int>(present),
    };
  }

  Assistance copyWith({int? studentId, String? date, int? present}) =>
      Assistance(
        studentId: studentId ?? this.studentId,
        date: date ?? this.date,
        present: present ?? this.present,
      );
  Assistance copyWithCompanion(AssistancesCompanion data) {
    return Assistance(
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      date: data.date.present ? data.date.value : this.date,
      present: data.present.present ? data.present.value : this.present,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Assistance(')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('present: $present')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(studentId, date, present);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Assistance &&
          other.studentId == this.studentId &&
          other.date == this.date &&
          other.present == this.present);
}

class AssistancesCompanion extends UpdateCompanion<Assistance> {
  final Value<int> studentId;
  final Value<String> date;
  final Value<int> present;
  final Value<int> rowid;
  const AssistancesCompanion({
    this.studentId = const Value.absent(),
    this.date = const Value.absent(),
    this.present = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssistancesCompanion.insert({
    required int studentId,
    required String date,
    required int present,
    this.rowid = const Value.absent(),
  }) : studentId = Value(studentId),
       date = Value(date),
       present = Value(present);
  static Insertable<Assistance> custom({
    Expression<int>? studentId,
    Expression<String>? date,
    Expression<int>? present,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (studentId != null) 'student_id': studentId,
      if (date != null) 'date': date,
      if (present != null) 'present': present,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssistancesCompanion copyWith({
    Value<int>? studentId,
    Value<String>? date,
    Value<int>? present,
    Value<int>? rowid,
  }) {
    return AssistancesCompanion(
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
      present: present ?? this.present,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (present.present) {
      map['present'] = Variable<int>(present.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssistancesCompanion(')
          ..write('studentId: $studentId, ')
          ..write('date: $date, ')
          ..write('present: $present, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $AssistancesTable assistances = $AssistancesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [students, assistances];
}

typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      required String name,
      required String major,
      required String shift,
      required String createdAt,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> major,
      Value<String> shift,
      Value<String> createdAt,
    });

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AssistancesTable, List<Assistance>>
  _assistancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.assistances,
    aliasName: 'students__id__assistances__student_id',
  );

  $$AssistancesTableProcessedTableManager get assistancesRefs {
    final manager = $$AssistancesTableTableManager(
      $_db,
      $_db.assistances,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_assistancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get major => $composableBuilder(
    column: $table.major,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assistancesRefs(
    Expression<bool> Function($$AssistancesTableFilterComposer f) f,
  ) {
    final $$AssistancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assistances,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssistancesTableFilterComposer(
            $db: $db,
            $table: $db.assistances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get major => $composableBuilder(
    column: $table.major,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shift => $composableBuilder(
    column: $table.shift,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get major =>
      $composableBuilder(column: $table.major, builder: (column) => column);

  GeneratedColumn<String> get shift =>
      $composableBuilder(column: $table.shift, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> assistancesRefs<T extends Object>(
    Expression<T> Function($$AssistancesTableAnnotationComposer a) f,
  ) {
    final $$AssistancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assistances,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssistancesTableAnnotationComposer(
            $db: $db,
            $table: $db.assistances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, $$StudentsTableReferences),
          Student,
          PrefetchHooks Function({bool assistancesRefs})
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> major = const Value.absent(),
                Value<String> shift = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                name: name,
                major: major,
                shift: shift,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String major,
                required String shift,
                required String createdAt,
              }) => StudentsCompanion.insert(
                id: id,
                name: name,
                major: major,
                shift: shift,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({assistancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (assistancesRefs) db.assistances],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (assistancesRefs)
                    await $_getPrefetchedData<
                      Student,
                      $StudentsTable,
                      Assistance
                    >(
                      currentTable: table,
                      referencedTable: $$StudentsTableReferences
                          ._assistancesRefsTable(db),
                      managerFromTypedResult: (p0) => $$StudentsTableReferences(
                        db,
                        table,
                        p0,
                      ).assistancesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.studentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, $$StudentsTableReferences),
      Student,
      PrefetchHooks Function({bool assistancesRefs})
    >;
typedef $$AssistancesTableCreateCompanionBuilder =
    AssistancesCompanion Function({
      required int studentId,
      required String date,
      required int present,
      Value<int> rowid,
    });
typedef $$AssistancesTableUpdateCompanionBuilder =
    AssistancesCompanion Function({
      Value<int> studentId,
      Value<String> date,
      Value<int> present,
      Value<int> rowid,
    });

final class $$AssistancesTableReferences
    extends BaseReferences<_$AppDatabase, $AssistancesTable, Assistance> {
  $$AssistancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('assistances__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AssistancesTableFilterComposer
    extends Composer<_$AppDatabase, $AssistancesTable> {
  $$AssistancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get present => $composableBuilder(
    column: $table.present,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssistancesTableOrderingComposer
    extends Composer<_$AppDatabase, $AssistancesTable> {
  $$AssistancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get present => $composableBuilder(
    column: $table.present,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssistancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssistancesTable> {
  $$AssistancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get present =>
      $composableBuilder(column: $table.present, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssistancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssistancesTable,
          Assistance,
          $$AssistancesTableFilterComposer,
          $$AssistancesTableOrderingComposer,
          $$AssistancesTableAnnotationComposer,
          $$AssistancesTableCreateCompanionBuilder,
          $$AssistancesTableUpdateCompanionBuilder,
          (Assistance, $$AssistancesTableReferences),
          Assistance,
          PrefetchHooks Function({bool studentId})
        > {
  $$AssistancesTableTableManager(_$AppDatabase db, $AssistancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssistancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssistancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssistancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> studentId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> present = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssistancesCompanion(
                studentId: studentId,
                date: date,
                present: present,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int studentId,
                required String date,
                required int present,
                Value<int> rowid = const Value.absent(),
              }) => AssistancesCompanion.insert(
                studentId: studentId,
                date: date,
                present: present,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AssistancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$AssistancesTableReferences
                                    ._studentIdTable(db),
                                referencedColumn: $$AssistancesTableReferences
                                    ._studentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AssistancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssistancesTable,
      Assistance,
      $$AssistancesTableFilterComposer,
      $$AssistancesTableOrderingComposer,
      $$AssistancesTableAnnotationComposer,
      $$AssistancesTableCreateCompanionBuilder,
      $$AssistancesTableUpdateCompanionBuilder,
      (Assistance, $$AssistancesTableReferences),
      Assistance,
      PrefetchHooks Function({bool studentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$AssistancesTableTableManager get assistances =>
      $$AssistancesTableTableManager(_db, _db.assistances);
}
