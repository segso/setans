import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../providers/student_detail_providers.dart';
import '../../../../theme/app_theme.dart';
import '../widgets/student_info_card.dart';

class StudentDetailScreen extends ConsumerWidget {
  final int studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider(studentId));
    final assistancesAsync = ref.watch(studentAssistancesProvider(studentId));
    final totalDatesAsync = ref.watch(totalDatesProvider);

    return studentAsync.when(
      data: (student) {
        if (student == null) {
          return const Center(child: Text('Estudiante no encontrado'));
        }
        return assistancesAsync.when(
          data: (assistances) => totalDatesAsync.when(
            data: (totalDates) {
              final presents =
                  assistances.where((a) => a.present == 1).length;
              final absents = totalDates - presents;
              return _DetailBody(
                student: student,
                assistances: assistances,
                presents: presents,
                absents: absents,
                totalDates: totalDates,
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

String _formatDate(String iso) {
  final parts = iso.split('-');
  return '${parts[2]}/${parts[1]}/${parts[0]}';
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
        _Badge(
          label: 'Presentes',
          count: presents,
          color: SetansTheme.present,
        ),
        const SizedBox(width: 12),
        _Badge(
          label: 'Faltas',
          count: absents,
          color: SetansTheme.absent,
        ),
        const SizedBox(width: 12),
        _Badge(
          label: 'Total',
          count: total,
          color: SetansTheme.primary,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _Badge({
    required this.label,
    required this.count,
    required this.color,
  });

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
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Student student;
  final List<Assistance> assistances;
  final int presents;
  final int absents;
  final int totalDates;
  final Future<void> Function(String name, String major, String shift) onSaved;

  const _DetailBody({
    required this.student,
    required this.assistances,
    required this.presents,
    required this.absents,
    required this.totalDates,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
            StudentInfoCard(
                student: student,
                presents: presents,
                absents: absents,
                total: totalDates,
                onSaved: onSaved,
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (assistances.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _StatsRow(
                            presents: presents,
                            absents: absents,
                            total: totalDates,
                          ),
                        ],
                    const SizedBox(height: 12),
                    if (assistances.isEmpty)
                      const Text('Sin registros de asistencia')
                    else
                      ...assistances.reversed.map(
                        (a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                a.present == 1
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: a.present == 1
                                    ? SetansTheme.present
                                    : SetansTheme.absent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(_formatDate(a.date)),
                              const Spacer(),
                              Text(
                                a.present == 1 ? 'Presente' : 'Ausente',
                                style: TextStyle(
                                  color: a.present == 1
                                      ? SetansTheme.present
                                      : SetansTheme.absent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
