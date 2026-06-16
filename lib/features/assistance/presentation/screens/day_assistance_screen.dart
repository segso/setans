import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../providers/assistance_providers.dart';
import '../widgets/assistance_table.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/fuzzy_search_field.dart';

class DayAssistanceScreen extends ConsumerWidget {
  final DateTime date;
  final void Function(int studentId)? onStudentTap;

  const DayAssistanceScreen({
    super.key,
    required this.date,
    this.onStudentTap,
  });

  String get _dateStr =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _toggle(WidgetRef ref, int studentId) async {
    final dao = ref.read(assistancesDaoProvider);
    final existing = await dao.getByDate(_dateStr);
    final current = existing.where((a) => a.studentId == studentId).firstOrNull;
    await dao.upsert(AssistancesCompanion(
      studentId: Value(studentId),
      date: Value(_dateStr),
      present: Value(current?.present == 1 ? 0 : 1),
    ));
    ref.read(mutationProvider.notifier).bump();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(dayStudentsProvider(date));
    final assistanceAsync = ref.watch(dayAssistanceProvider(date));
    final query = ref.watch(assistanceSearchProvider);

    final searchNotifier = ref.read(assistanceSearchProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: FuzzySearchField(
            hintText: 'Buscar por ID, nombre, especialidad o turno...',
            onChanged: (v) => searchNotifier.update(v),
          ),
        ),
        Expanded(
          child: studentsAsync.when(
            data: (students) {
              final filtered = _filter(students, query);
              return assistanceAsync.when(
                data: (assistanceMap) => AssistanceTable(
                  students: filtered,
                  assistanceMap: assistanceMap,
                  onToggle: (id) => _toggle(ref, id),
                  onStudentTap: onStudentTap,
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  List<Student> _filter(List<Student> students, String query) {
    if (query.isEmpty) return students;
    final q = query.toLowerCase();
    return students.where((s) {
      return s.id.toString().contains(q) ||
          s.name.toLowerCase().contains(q) ||
          s.major.toLowerCase().contains(q) ||
          s.shift.toLowerCase().contains(q);
    }).toList();
  }
}
