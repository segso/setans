import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';

class OverviewData {
  final List<Student> students;
  final List<String> dates;
  final Map<int, Map<String, int>> data;

  OverviewData({
    required this.students,
    required this.dates,
    required this.data,
  });

  String toCsv() {
    final sortedDates = dates.reversed.toList();
    final rows = <List<dynamic>>[
      ['Número de control', 'Nombre', 'Especialidad', 'Turno', ...sortedDates],
      ...students.map((s) => [
            s.id.toString(),
            s.name,
            s.major,
            s.shift,
            ...sortedDates.map((d) => (data[s.id]?[d] ?? 0)),
          ]),
    ];
    return const CsvEncoder(addBom: true).convert(rows);
  }

  Future<String?> saveCsv() async {
    final csv = toCsv();
    final bytes = utf8.encode(csv);

    try {
      final path = await FilePicker.saveFile(
        dialogTitle: 'Guardar archivo CSV',
        fileName:
            'asistencias_${DateTime.now().toIso8601String().split('T').first}.csv',
        bytes: Uint8List.fromList(bytes),
      );
      return path;
    } catch (_) {
      final home = Platform.environment['HOME'] ??
          Platform.environment['USERPROFILE'] ??
          '/tmp';
      final dir = Directory('$home/Downloads');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final path =
          '${dir.path}/asistencias_${DateTime.now().toIso8601String().split('T').first}.csv';
      await File(path).writeAsBytes(bytes);
      return path;
    }
  }
}

final overviewDataProvider = FutureProvider<OverviewData>((ref) async {
  ref.watch(mutationProvider);
  final studentsDao = ref.watch(studentsDaoProvider);
  final assistancesDao = ref.watch(assistancesDaoProvider);

  final students = await studentsDao.getAll();
  final assistances = await assistancesDao.getAll();

  final dateSet = <String>{};
  final data = <int, Map<String, int>>{};

  for (final a in assistances) {
    dateSet.add(a.date);
    data.putIfAbsent(a.studentId, () => {})[a.date] = a.present;
  }

  final dates = dateSet.toList()..sort();

  return OverviewData(students: students, dates: dates, data: data);
});

final overviewSearchProvider = NotifierProvider<OverviewSearchNotifier, String>(
  OverviewSearchNotifier.new,
);

class OverviewSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final filteredOverviewDataProvider = FutureProvider<OverviewData>((ref) async {
  ref.watch(mutationProvider);
  final data = await ref.watch(overviewDataProvider.future);
  final query = ref.watch(overviewSearchProvider);
  if (query.isEmpty) return data;
  final dao = ref.watch(studentsDaoProvider);
  final filtered = await dao.search(query);
  final filteredIds = filtered.map((s) => s.id).toSet();
  return OverviewData(
    students: data.students.where((s) => filteredIds.contains(s.id)).toList(),
    dates: data.dates,
    data: data.data,
  );
});
