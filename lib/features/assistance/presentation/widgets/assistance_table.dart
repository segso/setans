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

    return LayoutBuilder(
      builder: (context, constraints) {
        final vpw = constraints.maxWidth;
        const approxId = 160.0;
        final maxNameLen =
            students.fold<int>(0, (m, s) => s.name.length > m ? s.name.length : m);
        final approxName = (maxNameLen * 8.5).clamp(80.0, 500.0);
        final maxMajorLen =
            students.fold<int>(0, (m, s) => s.major.length > m ? s.major.length : m);
        final approxMajor = (maxMajorLen * 8.5).clamp(80.0, 300.0);
        final maxShiftLen =
            students.fold<int>(0, (m, s) => s.shift.length > m ? s.shift.length : m);
        final approxShift = (maxShiftLen * 8.5).clamp(50.0, 200.0);
        const approxSwitch = 80.0;
        final tableWidth =
            approxId + approxName + approxMajor + approxShift + approxSwitch + 32;
        final fill = vpw > tableWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: fill
              ? SizedBox(
                  width: vpw,
                  child: _buildDataTable(context, fill),
                )
              : _buildDataTable(context, fill),
        );
      },
    );
  }

  Widget _buildDataTable(BuildContext context, bool fill) {
    return SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        horizontalMargin: 10,
        headingRowColor: WidgetStateProperty.all(SetansTheme.surface),
        columnSpacing: 8,
        columns: [
          const DataColumn(
            label: Text('Número de control'),
            columnWidth: MaxColumnWidth(IntrinsicColumnWidth(), FixedColumnWidth(160)),
          ),
          DataColumn(
            label: const Text('Nombre'),
            columnWidth:
                fill ? const IntrinsicColumnWidth(flex: 1) : const IntrinsicColumnWidth(),
          ),
          const DataColumn(
            label: Text('Especialidad'),
            columnWidth: IntrinsicColumnWidth(),
          ),
          const DataColumn(
            label: Text('Turno'),
            columnWidth: IntrinsicColumnWidth(),
          ),
          const DataColumn(
            label: Text('Presente'),
            columnWidth: FixedColumnWidth(80),
          ),
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
