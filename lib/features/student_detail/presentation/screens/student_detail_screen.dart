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

    return studentAsync.when(
      data: (student) {
        if (student == null) {
          return const Center(child: Text('Estudiante no encontrado'));
        }
        return assistancesAsync.when(
          data: (assistances) => _DetailBody(
            student: student,
            assistances: assistances,
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
              ref.invalidate(studentProvider(studentId));
              ref.invalidate(studentAssistancesProvider(studentId));
            },
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

class _DetailBody extends StatelessWidget {
  final Student student;
  final List<Assistance> assistances;
  final Future<void> Function(String name, String major, String shift) onSaved;

  const _DetailBody({
    required this.student,
    required this.assistances,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StudentInfoCard(
            student: student,
            assistances: assistances,
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
                              Text(a.date),
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
