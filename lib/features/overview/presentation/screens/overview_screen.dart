import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/overview_providers.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/widgets/fuzzy_search_field.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  final void Function(int studentId)? onStudentTap;

  const OverviewScreen({super.key, this.onStudentTap});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(overviewSearchProvider.notifier).update(''));
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(filteredOverviewDataProvider);
    final searchNotifier = ref.read(overviewSearchProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: FuzzySearchField(
                  hintText: 'Buscar por ID, nombre, especialidad o turno...',
                  onChanged: (v) => searchNotifier.update(v),
                ),
              ),
              const SizedBox(width: 12),
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

    return Scrollbar(
      controller: _horizontalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: SingleChildScrollView(
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
                headingRowAlignment: MainAxisAlignment.center,
                label: Text(
                  label,
                  style: const TextStyle(fontSize: 10),
                ),
                columnWidth: const FixedColumnWidth(44),
              );
            }),
          ],
          rows: data.students.map((s) {
            final studentData = data.data[s.id] ?? {};
            return DataRow(
              onSelectChanged: (_) => widget.onStudentTap?.call(s.id),
              cells: [
                DataCell(
                  Text(s.name, overflow: TextOverflow.ellipsis),
                ),
                ...data.dates.map((d) {
                  final present = studentData[d] == 1;
                  return DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        present ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: present
                            ? SetansTheme.present
                            : SetansTheme.absent,
                      ),
                    ),
                    onTap: () => widget.onStudentTap?.call(s.id),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
      ),
    );
  }
}
