import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../providers/overview_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/widgets/fuzzy_search_field.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  final void Function(int studentId)? onStudentTap;
  final void Function(DateTime date)? onDateTap;

  const OverviewScreen({super.key, this.onStudentTap, this.onDateTap});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  Timer? _timer;
  int? _hoveredColumnIndex;
  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(overviewSearchProvider.notifier).update('');
      ref.read(overviewOverrideProvider.notifier).clear();
    });
  }

  Future<void> _toggleWithUndo(BuildContext context, int studentId, String dateStr, String studentName, bool isCurrentlyPresent) async {
    final label = isCurrentlyPresent ? 'ausente' : 'presente';

    final dao = ref.read(assistancesDaoProvider);
    final overrideNotifier = ref.read(overviewOverrideProvider.notifier);
    final existing = await dao.getByDate(dateStr);
    final current = existing.where((a) => a.studentId == studentId).firstOrNull;
    final newPresent = current?.present == 1 ? 0 : 1;
    await dao.upsert(AssistancesCompanion(
      studentId: Value(studentId),
      date: Value(dateStr),
      present: Value(newPresent),
    ));
    overrideNotifier.setOverride(studentId, dateStr, newPresent);

    if (!context.mounted) return;
    final messenger = _scaffoldMessenger ?? ScaffoldMessenger.of(context);
    _scaffoldMessenger = messenger;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$studentName marcado como $label'),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            _timer?.cancel();
            _scaffoldMessenger?.hideCurrentSnackBar();
            dao.upsert(AssistancesCompanion(
              studentId: Value(studentId),
              date: Value(dateStr),
              present: Value(isCurrentlyPresent ? 1 : 0),
            ));
            overrideNotifier.setOverride(studentId, dateStr, isCurrentlyPresent ? 1 : 0);
          },
        ),
      ),
    );
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 10), () {
      _scaffoldMessenger?.hideCurrentSnackBar();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldMessenger?.hideCurrentSnackBar();
    });
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(filteredOverviewDataProvider);
    final overrideMap = ref.watch(overviewOverrideProvider);
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
            data: (data) => _buildTable(context, data, overrideMap),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, OverviewData data) async {
    final overrides = ref.read(overviewOverrideProvider);
    final path = await data.saveCsv(overrides);
    if (path != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV guardado en: $path')),
      );
    }
  }

  Widget _buildTable(BuildContext context, OverviewData data, Map<String, int> overrideMap) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final currentYear = DateTime.now().year.toString();
        final dateTotal = data.dates.fold<double>(
          0,
          (sum, d) {
            final parts = d.split('-');
            final label = parts[0] == currentYear
                ? '${parts[2]}/${parts[1]}'
                : '${parts[2]}/${parts[1]}/${parts[0]}';
            return sum + label.length * 6.5;
          },
        );
        final maxNameLen =
            data.students.fold<int>(0, (m, s) => s.name.length > m ? s.name.length : m);
        const approxId = 160.0;
        final approxName = (maxNameLen * 8.5).clamp(80.0, 500.0);
        final tableWidth = dateTotal + approxId + approxName + 16;
        final hasExtraSpace = viewportWidth > tableWidth;

        return Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          notificationPredicate: (notification) =>
              notification.depth == 1 && notification.metrics.axis == Axis.horizontal,
          child: Scrollbar(
            controller: _verticalScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _verticalScrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horizontalScrollController,
                child: hasExtraSpace
                    ? SizedBox(
                        width: viewportWidth,
                        child: _buildDataTable(data, overrideMap, true),
                      )
                    : _buildDataTable(data, overrideMap, false),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataTable(OverviewData data, Map<String, int> overrideMap, bool fill) {
    final now = DateTime.now();
    final currentYear = now.year.toString();
    final today = DateTime(now.year, now.month, now.day);
    final dates = data.dates.reversed.toList();
    return DataTable(
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
          ...dates.asMap().entries.map((entry) {
            final colIdx = entry.key;
            final d = entry.value;
            final parts = d.split('-');
            final year = parts[0];
            final date = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            final isToday = date == today;
            final isHovered = _hoveredColumnIndex == colIdx;
            final label = year == currentYear
                ? '${parts[2]}/${parts[1]}'
                : '${parts[2]}/${parts[1]}/$year';
            return DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: MouseRegion(
                onEnter: (_) => setState(() => _hoveredColumnIndex = colIdx),
                onExit: (_) => setState(() => _hoveredColumnIndex = null),
                child: GestureDetector(
                  onTap: () => widget.onDateTap?.call(date),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? SetansTheme.primary.withValues(alpha: 0.12)
                          : isToday
                              ? SetansTheme.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isHovered || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isHovered || isToday ? SetansTheme.primary : null,
                      ),
                    ),
                  ),
                ),
              ),
              columnWidth: const IntrinsicColumnWidth(),
            );
          }),
        ],
        rows: data.students.map((s) {
          final studentData = data.data[s.id] ?? {};
          return DataRow(
            onSelectChanged: (_) => widget.onStudentTap?.call(s.id),
            cells: [
              DataCell(
                Text(s.id.toString()),
              ),
              DataCell(
                Text(s.name, overflow: TextOverflow.ellipsis),
              ),
              ...dates.map((d) {
                final overrideKey = '${s.id}|$d';
                final present = overrideMap.containsKey(overrideKey)
                    ? overrideMap[overrideKey] == 1
                    : studentData[d] == 1;
                return DataCell(
                  Align(
                    alignment: Alignment.center,
                    child: Tooltip(
                      message: present ? 'Marcar ausente' : 'Marcar presente',
                      child: Icon(
                        present ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: present ? SetansTheme.present : SetansTheme.absent,
                      ),
                    ),
                  ),
                  onTap: () => _toggleWithUndo(context, s.id, d, s.name, present),
                );
              }),
            ],
          );
        }).toList(),
    );
  }
}
