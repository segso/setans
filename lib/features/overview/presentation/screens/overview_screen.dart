import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/overview_providers.dart';
import '../../../../theme/app_theme.dart';

class OverviewScreen extends ConsumerWidget {
  final void Function(int studentId)? onStudentTap;

  const OverviewScreen({super.key, this.onStudentTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(overviewDataProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: dataAsync.maybeWhen(
                  data: (data) => () => _export(context, data),
                  orElse: () => null,
                ),
                icon: const Icon(Icons.file_download),
                label: const Text('Exportar CSV'),
              ),
            ],
          ),
        ),
        Expanded(
          child: dataAsync.when(
            data: (data) => _buildTable(context, data),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, OverviewData data) async {
    final path = await data.saveCsv();
    if (path != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV guardado en: $path')),
      );
    }
  }

  Widget _buildTable(BuildContext context, OverviewData data) {
    if (data.students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.table_chart_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No hay datos de asistencia',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          horizontalMargin: 4,
          headingRowColor: WidgetStateProperty.all(SetansTheme.surface),
          columnSpacing: 0,
          columns: [
            DataColumn(
              label: const Text('Estudiante'),
              columnWidth: const FixedColumnWidth(220),
            ),
            ...data.dates.map((d) {
              final parts = d.split('-');
              final label = '${parts[2]}/${parts[1]}';
              return DataColumn(
                label: Text(label, style: const TextStyle(fontSize: 11)),
                columnWidth: const FixedColumnWidth(32),
              );
            }),
          ],
          rows: data.students.map((s) {
            final studentData = data.data[s.id] ?? {};
            return DataRow(
              onSelectChanged: (_) => onStudentTap?.call(s.id),
              cells: [
                DataCell(
                  Text(s.name, overflow: TextOverflow.ellipsis),
                ),
                ...data.dates.map((d) {
                  final present = studentData[d] == 1;
                  return DataCell(
                    SizedBox(
                      width: double.infinity,
                      child: Icon(
                        present ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: present
                            ? SetansTheme.present
                            : SetansTheme.absent,
                      ),
                    ),
                    onTap: () => onStudentTap?.call(s.id),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
