import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../providers/assistance_providers.dart';
import '../widgets/assistance_table.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/fuzzy_search_field.dart';

class DayAssistanceScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final void Function(int studentId)? onStudentTap;

  const DayAssistanceScreen({
    super.key,
    required this.date,
    this.onStudentTap,
  });

  @override
  ConsumerState<DayAssistanceScreen> createState() =>
      _DayAssistanceScreenState();
}

class _DayAssistanceScreenState extends ConsumerState<DayAssistanceScreen> {
  String get _dateStr =>
      '${widget.date.year}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(assistanceSearchProvider.notifier).update('');
      ref.read(dayAssistanceOverrideProvider.notifier).clear();
    });
  }

  Future<void> _toggle(int studentId) async {
    final dao = ref.read(assistancesDaoProvider);
    final existing = await dao.getByDate(_dateStr);
    final current =
        existing.where((a) => a.studentId == studentId).firstOrNull;
    final newPresent = current?.present == 1 ? 0 : 1;
    await dao.upsert(AssistancesCompanion(
      studentId: Value(studentId),
      date: Value(_dateStr),
      present: Value(newPresent),
    ));
    ref.read(dayAssistanceOverrideProvider.notifier).setOverride(studentId, newPresent);
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(filteredDayStudentsProvider);
    final assistanceAsync = ref.watch(dayAssistanceProvider(widget.date));
    final overrideMap = ref.watch(dayAssistanceOverrideProvider);

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
            data: (students) => assistanceAsync.when(
              data: (assistanceMap) {
                final mergedMap = <int, Assistance>{};
                mergedMap.addAll(assistanceMap);
                for (final entry in overrideMap.entries) {
                  mergedMap[entry.key] = Assistance(
                    studentId: entry.key,
                    date: _dateStr,
                    present: entry.value,
                  );
                }
                return AssistanceTable(
                  students: students,
                  assistanceMap: mergedMap,
                  onToggle: _toggle,
                  onStudentTap: widget.onStudentTap,
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
