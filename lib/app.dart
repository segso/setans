import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'shared/widgets/app_menubar.dart';
import 'features/calendar/presentation/screens/calendar_screen.dart';
import 'features/register/presentation/screens/register_screen.dart';
import 'shared/providers/shared_providers.dart';
import 'features/assistance/presentation/screens/day_assistance_screen.dart';
import 'features/student_detail/presentation/screens/student_detail_screen.dart';
import 'features/student_detail/presentation/providers/student_detail_providers.dart';
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
  int? _restoredYear;
  MenuItem? _previousMenuItem;
  late final TutorialManager _tutorialManager;
  final Map<int, int> _studentYears = {};
  bool _tutorialRunning = false;

  @override
  void initState() {
    super.initState();
    _tutorialManager = TutorialManager();
    _tutorialManager.onNavigate = _navigateForTutorial;
    _tutorialManager.showcaseView.addOnFinishCallback(_onTutorialEnded);
    _tutorialManager.showcaseView.addOnDismissCallback((_) => _onTutorialEnded());
  }

  void _onTutorialEnded() {
    if (mounted) {
      setState(() {
        _tutorialRunning = false;
        _selectedItem = MenuItem.calendar;
        _selectedDate = null;
        _selectedStudentId = null;
        _returnToStudentId = null;
        _restoredYear = null;
        _previousMenuItem = null;
      });
    }
  }

  Future<void> _navigateForTutorial(TutorialNavigation action) async {
    switch (action) {
      case TutorialNavigation.showCalendar:
        _onMenuItemSelected(MenuItem.calendar);
      case TutorialNavigation.showRegister:
        _onMenuItemSelected(MenuItem.register);
      case TutorialNavigation.showOverview:
        _onMenuItemSelected(MenuItem.overview);
      case TutorialNavigation.showDayForDate:
        _onDaySelected(DateTime.now());
      case TutorialNavigation.showStudentDetail:
        ref.read(quickActionStatusProvider.notifier).setStatus(null);
        ref.read(mutationProvider.notifier).bump();
        final dao = ref.read(studentsDaoProvider);
        final students = await dao.getAll();
        if (students.isEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Registra al menos un estudiante para ver esta sección.',
              ),
            ),
          );
          _tutorialManager.showcaseView.dismiss();
          return;
        }
        _onStudentTap(students.first.id);
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void _onMenuItemSelected(MenuItem item) {
    switch (item) {
      case MenuItem.tutorial:
        _onMenuItemSelected(MenuItem.calendar);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tutorialManager.startTutorial();
          setState(() => _tutorialRunning = true);
        });
        return;
      case MenuItem.about:
        showDialog(
          context: context,
          builder: (_) => const AboutDialogWidget(),
        );
        return;
      default:
        ref.read(quickActionStatusProvider.notifier).setStatus(null);
        ref.read(mutationProvider.notifier).bump();
        setState(() {
          _selectedItem = item;
          _selectedDate = null;
          _selectedStudentId = null;
          _returnToStudentId = null;
          _restoredYear = null;
          _previousMenuItem = null;
        });
    }
  }

  void _onDaySelected(DateTime date) {
    ref.read(mutationProvider.notifier).bump();
    setState(() {
      _selectedDate = date;
      _previousMenuItem = _selectedItem;
      _selectedItem = MenuItem.calendar;
      if (_selectedStudentId != null) {
        _returnToStudentId = _selectedStudentId;
        _restoredYear = _studentYears[_selectedStudentId];
      }
      _selectedStudentId = null;
    });
  }

  void _onBackToCalendar() {
    ref.read(mutationProvider.notifier).bump();
    setState(() {
      if (_returnToStudentId != null) {
        _selectedStudentId = _returnToStudentId;
        if (_restoredYear != null) {
          _studentYears[_selectedStudentId!] = _restoredYear!;
          _restoredYear = null;
        }
        _returnToStudentId = null;
      } else if (_previousMenuItem != null) {
        _selectedItem = _previousMenuItem!;
        _previousMenuItem = null;
      }
      _selectedDate = null;
    });
  }

  void _onStudentTap(int studentId) {
    ref.read(mutationProvider.notifier).bump();
    setState(() {
      _selectedStudentId = studentId;
      _studentYears.remove(studentId);
    });
  }

  void _onBackFromStudent() {
    ref.read(quickActionStatusProvider.notifier).setStatus(null);
    ref.read(mutationProvider.notifier).bump();
    setState(() {
      _selectedStudentId = null;
      _returnToStudentId = null;
      _restoredYear = null;
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
      ref.read(quickActionStatusProvider.notifier).setStatus(null);
      ref.read(mutationProvider.notifier).bump();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setans',
      debugShowCheckedModeBanner: false,
      theme: SetansTheme.light,
      home: TutorialManager.wrapCalendarStep(
        child: TutorialManager.wrapRegisterStep(
          child: TutorialManager.wrapDayAssistanceStep(
            child: TutorialManager.wrapOverviewStep(
              child: TutorialManager.wrapStudentDetailStep(
                child: _tutorialRunning
                    ? Stack(
                        children: [
                          AbsorbPointer(
                            absorbing: true,
                            child: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: const Size.fromHeight(48),
                                child: AppMenubar(
                                  selected: _selectedItem,
                                  onItemSelected: _onMenuItemSelected,
                                ),
                              ),
                              body: _buildBody(),
                            ),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: TutorialManager.handleBarrierClick,
                              child: Container(color: Colors.black45),
                            ),
                          ),
                        ],
                      )
                    : Scaffold(
                        appBar: PreferredSize(
                          preferredSize: const Size.fromHeight(48),
                          child: AppMenubar(
                            selected: _selectedItem,
                            onItemSelected: _onMenuItemSelected,
                          ),
                        ),
                        body: _buildBody(),
                      ),
              ),
            ),
          ),
        ),
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
              currentYear: _studentYears[_selectedStudentId!] ?? DateTime.now().year,
              onYearChanged: (offset) {
                setState(() {
                  _studentYears[_selectedStudentId!] =
                      (_studentYears[_selectedStudentId!] ?? DateTime.now().year) + offset;
                });
              },
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
                  label: const Text('Volver'),
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
        return OverviewScreen(onStudentTap: _onStudentTap, onDateTap: _onDaySelected);
      case MenuItem.tutorial:
      case MenuItem.about:
        return CalendarScreen(onDaySelected: _onDaySelected);
    }
  }
}
