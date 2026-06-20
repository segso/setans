import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../shared/widgets/year_calendar.dart';
import '../providers/student_detail_providers.dart';
import '../../../../theme/app_theme.dart';
import '../widgets/student_info_card.dart';
import '../widgets/quick_action_bar.dart';

class StudentDetailScreen extends ConsumerWidget {
  final int studentId;
  final int currentYear;
  final void Function(int offset) onYearChanged;
  final void Function(DateTime date)? onDateTap;

  const StudentDetailScreen({
    super.key,
    required this.studentId,
    required this.currentYear,
    required this.onYearChanged,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider(studentId));
    final assistancesAsync = ref.watch(studentAssistancesProvider(studentId));
    final totalDatesAsync = ref.watch(totalDatesProvider);
    final allDatesAsync = ref.watch(allDatesProvider);

    return studentAsync.when(
      data: (student) {
        if (student == null) {
          return const Center(child: Text('Estudiante no encontrado'));
        }
        return assistancesAsync.when(
          data: (assistances) => totalDatesAsync.when(
            data: (totalDates) => allDatesAsync.when(
              data: (allDates) {
                final presents = assistances
                    .where((a) => a.present == 1)
                    .length;
                final absents = totalDates - presents;
                final quickActionStatus = ref.watch(quickActionStatusProvider);
                return _DetailBody(
                  student: student,
                  assistances: assistances,
                  allDates: allDates,
                  presents: presents,
                  absents: absents,
                  totalDates: totalDates,
                  currentYear: currentYear,
                  onYearChanged: onYearChanged,
                  onDateTap: onDateTap,
                  quickActionStatus: quickActionStatus,
                  onSaved: (name, major, shift) async {
                    final dao = ref.read(studentsDaoProvider);
                    await dao.updateStudent(
                      StudentsCompanion(
                        id: drift.Value(student.id),
                        name: drift.Value(name),
                        major: drift.Value(major),
                        shift: drift.Value(shift),
                        createdAt: drift.Value(student.createdAt),
                      ),
                    );
                    ref.read(mutationProvider.notifier).bump();
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int presents;
  final int absents;
  final int total;
  const _StatsRow({
    required this.presents,
    required this.absents,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Badge(label: 'Presentes', count: presents, color: SetansTheme.present),
        const SizedBox(width: 12),
        _Badge(label: 'Faltas', count: absents, color: SetansTheme.absent),
        const SizedBox(width: 12),
        _Badge(label: 'Total', count: total, color: SetansTheme.primary),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _Badge({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Student student;
  final List<Assistance> assistances;
  final List<String> allDates;
  final int presents;
  final int absents;
  final int totalDates;
  final int currentYear;
  final int? quickActionStatus;
  final void Function(int offset) onYearChanged;
  final Future<void> Function(String name, String major, String shift) onSaved;
  final void Function(DateTime date)? onDateTap;

  const _DetailBody({
    required this.student,
    required this.assistances,
    required this.allDates,
    required this.presents,
    required this.absents,
    required this.totalDates,
    required this.currentYear,
    required this.onYearChanged,
    this.quickActionStatus,
    required this.onSaved,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final presentDays = assistances.where((a) => a.present == 1).map((a) {
      final parts = a.date.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toSet();

    final absentDays = allDates
        .where((d) {
          final record = assistances.where((a) => a.date == d).firstOrNull;
          return record == null || record.present == 0;
        })
        .map((d) {
          final parts = d.split('-');
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        })
        .toSet();

    if (quickActionStatus == 1) {
      presentDays.add(today);
      absentDays.remove(today);
    } else if (quickActionStatus == 0) {
      absentDays.add(today);
      presentDays.remove(today);
    }

    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final todayRecordInDb = assistances.where((a) => a.date == todayStr).firstOrNull;
    final isTodayPresentInDb = todayRecordInDb?.present == 1;

    int adjustedPresents = presents;
    int adjustedAbsents = absents;
    if (quickActionStatus == 1 && !isTodayPresentInDb) {
      adjustedPresents += 1;
      adjustedAbsents -= 1;
    } else if (quickActionStatus == 0 && isTodayPresentInDb) {
      adjustedPresents -= 1;
      adjustedAbsents += 1;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          StudentInfoCard(
            student: student,
            onSaved: onSaved,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: QuickActionBar(
              studentId: student.id,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historial de asistencias',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (allDates.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _StatsRow(
                        presents: adjustedPresents,
                        absents: adjustedAbsents,
                        total: totalDates,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (allDates.isEmpty)
                      const Text('Sin registros de asistencia')
                    else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_left, size: 32),
                            onPressed: () => onYearChanged(-1),
                          ),
                          Text(
                            '$currentYear',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_right, size: 32),
                            onPressed: () => onYearChanged(1),
                          ),
                        ],
                      ),
                      YearCalendar(
                        year: currentYear,
                        today: today,
                        onDayTap: onDateTap,
                        presentDays: presentDays,
                        absentDays: absentDays,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
