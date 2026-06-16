import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../theme/app_theme.dart';

class StudentTable extends StatelessWidget {
  final List<Student> students;
  final void Function(int studentId) onStudentTap;
  final Future<void> Function(int studentId) onDeleteStudent;

  const StudentTable({
    super.key,
    required this.students,
    required this.onStudentTap,
    required this.onDeleteStudent,
  });

  Future<void> _confirmDelete(BuildContext context, Student s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar estudiante'),
        content: Text(
          '¿Eliminar a "${s.name}" (#${s.id})? También se borrarán '
          'todos sus registros de asistencia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: SetansTheme.absent,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await onDeleteStudent(s.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No se encontraron estudiantes',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(SetansTheme.surface),
          columns: const [
            DataColumn(
              label: Text('ID'),
              columnWidth: FlexColumnWidth(0.8),
            ),
            DataColumn(
              label: Text('Nombre'),
              columnWidth: FlexColumnWidth(3),
            ),
            DataColumn(
              label: Text('Especialidad'),
              columnWidth: FlexColumnWidth(2),
            ),
            DataColumn(
              label: Text('Turno'),
              columnWidth: FlexColumnWidth(1.5),
            ),
            DataColumn(
              label: Text(''),
              columnWidth: FixedColumnWidth(48),
            ),
          ],
          rows: students.map((s) {
            return DataRow(
              onSelectChanged: (_) => onStudentTap(s.id),
              cells: [
                DataCell(Text(s.id.toString())),
                DataCell(Text(s.name)),
                DataCell(Text(s.major)),
                DataCell(Text(s.shift)),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: SetansTheme.absent,
                    onPressed: () => _confirmDelete(context, s),
                    tooltip: 'Eliminar',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
