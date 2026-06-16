import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../theme/app_theme.dart';

class AssistanceTable extends StatelessWidget {
  final List<Student> students;
  final Map<int, Assistance> assistanceMap;
  final void Function(int studentId) onToggle;
  final void Function(int studentId)? onStudentTap;

  const AssistanceTable({
    super.key,
    required this.students,
    required this.assistanceMap,
    required this.onToggle,
    this.onStudentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline,
                size: 48, color: Colors.grey.shade400),
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
      child: DataTable(
        showCheckboxColumn: false,
        horizontalMargin: 8,
        headingRowColor: WidgetStateProperty.all(SetansTheme.surface),
        columns: const [
          DataColumn(label: Text('Número de control')),
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Especialidad')),
          DataColumn(label: Text('Turno')),
          DataColumn(label: Text('Presente')),
        ],
        rows: students.map((s) {
          final assistance = assistanceMap[s.id];
          final present = assistance?.present == 1;
          return DataRow(
            onSelectChanged: (_) => onStudentTap?.call(s.id),
            cells: [
              DataCell(Text(s.id.toString())),
              DataCell(Text(s.name, overflow: TextOverflow.ellipsis)),
              DataCell(Text(s.major, overflow: TextOverflow.ellipsis)),
              DataCell(Text(s.shift)),
              DataCell(
                Switch(
                  value: present,
                  activeTrackColor: SetansTheme.present,
                  onChanged: (_) => onToggle(s.id),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
