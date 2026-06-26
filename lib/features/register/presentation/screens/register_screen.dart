import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/register_providers.dart';
import '../widgets/student_table.dart';
import 'student_form_screen.dart';
import '../../../../shared/widgets/fuzzy_search_field.dart';
import '../../../../shared/providers/shared_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final void Function(int studentId)? onStudentTap;

  const RegisterScreen({super.key, this.onStudentTap});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(studentSearchProvider.notifier).update('');
    });
  }

  Future<void> _openForm(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormScreen()),
    );
    if (result == true) {
      ref.read(mutationProvider.notifier).bump();
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(filteredStudentsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: FuzzySearchField(
                  hintText: 'Buscar por ID, nombre, especialidad o turno...',
                  onChanged: (v) =>
                      ref.read(studentSearchProvider.notifier).update(v),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _openForm(context),
                icon: const Icon(Icons.person_add),
                label: const Text('Agregar estudiante'),
              ),
            ],
          ),
        ),
        Expanded(
          child: studentsAsync.when(
            data: (students) => StudentTable(
              students: students,
              onStudentTap: widget.onStudentTap ?? (_) {},
              onDeleteStudent: (id) async {
                await ref.read(studentsDaoProvider).deleteStudent(id);
                ref.read(mutationProvider.notifier).bump();
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
