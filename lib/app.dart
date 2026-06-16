import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'shared/widgets/app_menubar.dart';
import 'features/calendar/presentation/screens/calendar_screen.dart';
import 'features/register/presentation/screens/register_screen.dart';
import 'shared/providers/shared_providers.dart';
import 'features/assistance/presentation/screens/day_assistance_screen.dart';
import 'features/student_detail/presentation/screens/student_detail_screen.dart';
import 'features/overview/presentation/screens/overview_screen.dart';
import 'features/tutorial/presentation/widgets/tutorial_manager.dart';
import 'features/about/presentation/widgets/about_dialog.dart';

class SetansApp extends ConsumerStatefulWidget {
  const SetansApp({super.key});

  @override
  ConsumerState<SetansApp> createState() => _SetansAppState();
}

class _SetansAppState extends ConsumerState<SetansApp> {
  MenuItem _selectedItem = MenuItem.calendar;
  DateTime? _selectedDate;
  int? _selectedStudentId;
  int? _returnToStudentId;
  final _tutorialManager = TutorialManager();

  void _onMenuItemSelected(MenuItem item) {
    switch (item) {
      case MenuItem.tutorial:
        _tutorialManager.startTutorial(context);
        return;
      case MenuItem.about:
        showDialog(
          context: context,
          builder: (_) => const AboutDialogWidget(),
        );
        return;
      default:
        setState(() {
          _selectedItem = item;
          _selectedDate = null;
          _selectedStudentId = null;
          _returnToStudentId = null;
        });
    }
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedItem = MenuItem.calendar;
      if (_selectedStudentId != null) {
        _returnToStudentId = _selectedStudentId;
      }
      _selectedStudentId = null;
    });
  }

  void _onBackToCalendar() {
    ref.read(mutationProvider.notifier).bump();
    setState(() {
      if (_returnToStudentId != null) {
        _selectedStudentId = _returnToStudentId;
        _returnToStudentId = null;
      }
      _selectedDate = null;
    });
  }

  void _onStudentTap(int studentId) {
    setState(() => _selectedStudentId = studentId);
  }

  void _onBackFromStudent() {
    ref.read(mutationProvider.notifier).bump();
    setState(() {
      _selectedStudentId = null;
      _returnToStudentId = null;
    });
  }

  Future<void> _deleteDay(BuildContext context, DateTime date) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar día'),
        content: Text(
          '¿Eliminar todos los registros de asistencia del '
          '${date.day}/${date.month}/${date.year}?',
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
    if (confirmed == true && context.mounted) {
      final dao = ref.read(assistancesDaoProvider);
      await dao.deleteByDate(dateStr);
      ref.read(mutationProvider.notifier).bump();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setans',
      debugShowCheckedModeBanner: false,
      theme: SetansTheme.light,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppMenubar(
            selected: _selectedItem,
            onItemSelected: _onMenuItemSelected,
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedStudentId != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _onBackFromStudent,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StudentDetailScreen(
              studentId: _selectedStudentId!,
              onDateTap: _onDaySelected,
            ),
          ),
        ],
      );
    }

    if (_selectedDate != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _onBackToCalendar,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(
                      _returnToStudentId != null ? 'Volver' : 'Calendario'),
                ),
                const Spacer(),
                Text(
                  '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Builder(
                  builder: (innerContext) => IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: SetansTheme.absent),
                    tooltip: 'Eliminar día',
                    onPressed: () => _deleteDay(innerContext, _selectedDate!),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: DayAssistanceScreen(
                  date: _selectedDate!,
                  onStudentTap: _onStudentTap,
                ),
          ),
        ],
      );
    }

    switch (_selectedItem) {
      case MenuItem.calendar:
        return CalendarScreen(onDaySelected: _onDaySelected);
      case MenuItem.register:
        return RegisterScreen(onStudentTap: _onStudentTap);
      case MenuItem.overview:
        return OverviewScreen(onStudentTap: _onStudentTap);
      case MenuItem.tutorial:
      case MenuItem.about:
        return CalendarScreen(onDaySelected: _onDaySelected);
    }
  }
}
