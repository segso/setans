import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class TutorialStep {
  final GlobalKey targetKey;
  final String title;
  final String content;
  final TutorialNavigation? navigation;
  final TooltipPosition? position;

  const TutorialStep({
    required this.targetKey,
    required this.title,
    required this.content,
    this.navigation,
    this.position,
  });
}

enum TutorialNavigation {
  showCalendar,
  showRegister,
  showDayForDate,
  showOverview,
  showStudentDetail,
}

class TutorialManager {
  static final GlobalKey calendarKey = GlobalKey();
  static final GlobalKey registerKey = GlobalKey();
  static final GlobalKey dayAssistanceKey = GlobalKey();
  static final GlobalKey overviewKey = GlobalKey();
  static final GlobalKey quickActionKey = GlobalKey();

  static TutorialManager? _instance;

  final List<TutorialStep> _steps;
  late final ShowcaseView _showcaseView;
  bool _isAdvancing = false;
  bool _isRunning = false;

  Future<void> Function(TutorialNavigation action)? onNavigate;

  TutorialManager._init()
      : _steps = _initSteps() {
    _showcaseView = ShowcaseView.register(
      disableBarrierInteraction: true,
      skipIfTargetNotPresent: true,
      onFinish: _onFinish,
      onDismiss: (_) => _onFinish(),
      globalTooltipActionConfig: const TooltipActionConfig(
        alignment: MainAxisAlignment.end,
        actionGap: 6,
        position: TooltipActionPosition.outside,
      ),
      globalTooltipActions: _buildActions(),
    );
  }

  factory TutorialManager() {
    _instance ??= TutorialManager._init();
    return _instance!;
  }

  static List<TutorialStep> _initSteps() {
    return [
      TutorialStep(
        targetKey: calendarKey,
        title: 'Calendario principal',
        content:
            '• Navega entre años con las flechas ◀ ▶ ubicadas en la parte superior\n'
            '• Cliquea un día para ver y modificar las asistencias de ese día',
        navigation: TutorialNavigation.showCalendar,
      ),
      TutorialStep(
        targetKey: registerKey,
        title: 'Registro de estudiantes',
        content:
            'Aquí puedes gestionar todos los estudiantes registrados.\n\n'
            '• Usa el campo de búsqueda para filtrar por número de control, '
            'nombre, especialidad o turno\n'
            '• Cliquea un estudiante para ver sus datos y asistencias\n'
            '• Presiona "Nuevo" para agregar un estudiante\n'
            '• Cliquea el ícono de eliminar para borrar un estudiante',
        navigation: TutorialNavigation.showRegister,
      ),
      TutorialStep(
        targetKey: dayAssistanceKey,
        title: 'Asistencia del día',
        content:
            'Esta pantalla muestra la asistencia de todos los estudiantes '
            'para un día específico.\n\n'
            '• Cada estudiante tiene un interruptor para marcarlo '
            'como presente o ausente\n'
            '• Usa el campo de búsqueda para filtrar estudiantes\n'
            '• Cliquea el nombre de un estudiante para ver sus datos y asistencias\n'
            '• Presiona el ícono de eliminar en la parte superior para borrar todos '
            'los registros de este día',
        navigation: TutorialNavigation.showDayForDate,
      ),
      TutorialStep(
        targetKey: overviewKey,
        title: 'Vista general',
        content:
            'La vista general presenta una tabla completa con todos los '
            'estudiantes y todas las fechas con asistencias registradas.\n\n'
            '• El ícono de verificado verde indica Presente, la equis roja indica Ausente\n'
            '• Cliquea el ícono de verificado/equis para cambiar la asistencia\n'
            '• Cliquea la fecha en el encabezado para ir a la asistencia de ese día\n'
            '• Cliquea un estudiante para ver sus datos y asistencias\n'
            '• Presiona "Exportar CSV" para exportar la tabla como archivo',
        navigation: TutorialNavigation.showOverview,
      ),
      TutorialStep(
        targetKey: quickActionKey,
        title: 'Información del estudiante',
        content:
            'Esta pantalla muestra la información completa del estudiante '
            'y su historial de asistencia.\n\n'
            '• Puedes editar nombre, especialidad y turno con el ícono del lápiz\n'
            '• El calendario resalta los días con asistencia registrada\n'
            '• Los botones "Marcar presente hoy" y "Marcar ausente hoy" permiten '
            'registrar rápidamente la asistencia del día actual\n'
            '• Los conteos de presentes, ausencias y total se muestran al inicio del historial',
        navigation: TutorialNavigation.showStudentDetail,
      ),
    ];
  }

  bool get isRunning => _isRunning;
  ShowcaseView get showcaseView => _showcaseView;
  int get stepCount => _steps.length;
  List<GlobalKey> get keys => _steps.map((s) => s.targetKey).toList();

  void startTutorial() {
    _isAdvancing = false;
    _isRunning = true;
    _showcaseView.startShowCase(
      _steps.map((s) => s.targetKey).toList(),
    );
  }

  List<TooltipActionButton> _buildActions({bool showPrevious = true}) {
    return [
      if (showPrevious)
        TooltipActionButton(
          type: TooltipDefaultActionType.previous,
          name: 'Anterior',
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Color(0xFF1565C0)),
          border: Border.all(color: const Color(0xFF1565C0)),
          borderRadius: BorderRadius.circular(6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          onTap: _handlePrevious,
        ),
      TooltipActionButton(
        type: TooltipDefaultActionType.skip,
        name: 'Saltar',
        backgroundColor: const Color(0xFFE0E0E0),
        textStyle: const TextStyle(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: 'Siguiente',
        backgroundColor: const Color(0xFF1565C0),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        onTap: _handleNext,
      ),
    ];
  }

  static List<TooltipActionButton> _skipNextActions() {
    return [
      TooltipActionButton(
        type: TooltipDefaultActionType.skip,
        name: 'Saltar',
        backgroundColor: const Color(0xFFE0E0E0),
        textStyle: const TextStyle(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      TooltipActionButton(
        type: TooltipDefaultActionType.next,
        name: 'Siguiente',
        backgroundColor: const Color(0xFF1565C0),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        borderRadius: BorderRadius.circular(6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        onTap: handleBarrierClick,
      ),
    ];
  }

  static void handleBarrierClick() {
    _instance?._handleNext();
  }

  void _handleNext() {
    if (_isAdvancing) return;
    _isAdvancing = true;

    final activeKey = _showcaseView.getActiveShowcaseKey;
    if (activeKey == null) {
      _isAdvancing = false;
      return;
    }

    final currentIndex = _steps.indexWhere((s) => s.targetKey == activeKey);
    if (currentIndex < 0) {
      _isAdvancing = false;
      return;
    }

    final nextIndex = currentIndex + 1;
    if (nextIndex >= _steps.length) {
      _showcaseView.next(force: true);
      _isAdvancing = false;
      return;
    }

    _advanceTo(nextIndex);
  }

  void _handlePrevious() {
    if (_isAdvancing) return;
    _isAdvancing = true;

    final activeKey = _showcaseView.getActiveShowcaseKey;
    if (activeKey == null) {
      _isAdvancing = false;
      return;
    }

    final currentIndex = _steps.indexWhere((s) => s.targetKey == activeKey);
    if (currentIndex <= 0) {
      _isAdvancing = false;
      return;
    }

    final prevIndex = currentIndex - 1;
    final prevStep = _steps[prevIndex];
    final prevNav = prevStep.navigation;

    if (prevNav != null && onNavigate != null) {
      onNavigate!(prevNav);
    }

    _showcaseView.previous();
    _isAdvancing = false;
  }

  void _advanceTo(int stepIndex) {
    final step = _steps[stepIndex];
    final nav = step.navigation;

    _showcaseView.next(force: true);

    if (nav != null && onNavigate != null) {
      onNavigate!(nav);
    }

    _isAdvancing = false;
  }

  static InlineSpan _iconSpan(IconData icon, {Color? color, double size = 16}) {
    return WidgetSpan(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Icon(icon, size: size, color: color),
      ),
      alignment: PlaceholderAlignment.middle,
    );
  }

  static Widget buildTooltipContent(
    String title,
    List<InlineSpan> descriptionSpans, {
    IconData icon = Icons.touch_app,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 20, color: Color(0xFF1565C0)),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(children: descriptionSpans),
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF424242),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  static Widget wrapCalendarStep({required Widget child}) {
    return Showcase.withWidget(
      key: calendarKey,
      container: buildTooltipContent(
        'Calendario principal',
        [
          const TextSpan(text: '• Navega entre años con las flechas'),
          WidgetSpan(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_left, size: 20),
                Icon(Icons.arrow_right, size: 20),
              ],
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          const TextSpan(text: 'ubicadas en la parte superior\n'
              '• Cliquea un día para ver y modificar las asistencias de ese día'),
        ],
        icon: Icons.calendar_month,
      ),
      tooltipActions: _skipNextActions(),
      disableMovingAnimation: true,
      onBarrierClick: handleBarrierClick,
      onTargetClick: handleBarrierClick,
      disposeOnTap: false,
      child: child,
    );
  }

  static Widget wrapRegisterStep({required Widget child}) {
    return Showcase.withWidget(
      key: registerKey,
      container: buildTooltipContent(
        'Registro de estudiantes',
        [
          const TextSpan(text: 'Aquí puedes gestionar todos los estudiantes registrados.\n\n'
              '• Usa el campo de búsqueda para filtrar por número de control, '
              'nombre, especialidad o turno\n'
              '• Cliquea un estudiante para ver sus datos y asistencias\n'
              '• Presiona "'),
          _iconSpan(Icons.add),
          const TextSpan(text: ' Nuevo" para agregar un estudiante\n'
              '• Cliquea '),
          _iconSpan(Icons.delete_outline, color: Color(0xFFC62828)),
          const TextSpan(text: ' para borrar un estudiante'),
        ],
        icon: Icons.people,
      ),
      disableMovingAnimation: true,
      onBarrierClick: handleBarrierClick,
      onTargetClick: handleBarrierClick,
      disposeOnTap: false,
      child: child,
    );
  }

  static Widget wrapDayAssistanceStep({required Widget child}) {
    return Showcase.withWidget(
      key: dayAssistanceKey,
      container: buildTooltipContent(
        'Asistencia del día',
        [
          const TextSpan(text: 'Esta pantalla muestra la asistencia de todos los estudiantes '
              'para un día específico.\n\n'
              '• Cada estudiante tiene un interruptor '),
          _iconSpan(Icons.toggle_off_outlined, color: Color(0xFF757575)),
          const TextSpan(text: ' para marcarlo '
              'como presente o ausente\n'
              '• Usa el campo de búsqueda para filtrar estudiantes\n'
              '• Cliquea el nombre de un estudiante para ver sus datos y asistencias\n'
              '• Presiona '),
          _iconSpan(Icons.delete_outline, color: Color(0xFFC62828)),
          const TextSpan(text: ' en la parte superior para borrar todos '
              'los registros de este día'),
        ],
        icon: Icons.checklist,
      ),
      disableMovingAnimation: true,
      onBarrierClick: handleBarrierClick,
      onTargetClick: handleBarrierClick,
      disposeOnTap: false,
      child: child,
    );
  }

  static Widget wrapOverviewStep({required Widget child}) {
    return Showcase.withWidget(
      key: overviewKey,
      container: buildTooltipContent(
        'Vista general',
        [
          const TextSpan(text: 'La vista general presenta una tabla completa con todos los '
              'estudiantes y todas las fechas con asistencias registradas.\n\n'
              '• El ícono '),
          _iconSpan(Icons.check_circle, color: Color(0xFF2E7D32)),
          const TextSpan(text: ' indica presente, el ícono '),
          _iconSpan(Icons.cancel, color: Color(0xFFC62828)),
          const TextSpan(text: ' indica ausente\n'
              '• Cliquea el ícono '),
          _iconSpan(Icons.check_circle, color: Color(0xFF2E7D32)),
          const TextSpan(text: '/'),
          _iconSpan(Icons.cancel, color: Color(0xFFC62828)),
          const TextSpan(text: ' para cambiar la asistencia\n'
              '• Cliquea la fecha en el encabezado para ir a la asistencia de ese día\n'
              '• Cliquea un estudiante para ver sus datos y asistencias\n'
              '• Presiona "'),
          _iconSpan(Icons.file_download),
          const TextSpan(text: ' Exportar CSV" para exportar la tabla como archivo'),
        ],
        icon: Icons.table_chart,
      ),
      disableMovingAnimation: true,
      onBarrierClick: handleBarrierClick,
      onTargetClick: handleBarrierClick,
      disposeOnTap: false,
      child: child,
    );
  }

  static Widget wrapStudentDetailStep({required Widget child}) {
    return Showcase.withWidget(
      key: quickActionKey,
      container: buildTooltipContent(
        'Información del estudiante',
        [
          const TextSpan(text: 'Esta pantalla muestra la información completa del estudiante '
              'y su historial de asistencia.\n\n'
              '• Puedes editar nombre, especialidad y turno con '),
          _iconSpan(Icons.edit, color: Color(0xFF616161)),
          const TextSpan(text: '\n'
              '• El calendario resalta los días con asistencia registrada\n'
              '• Los botones "Marcar presente hoy" y "Marcar ausente hoy" permiten '
              'registrar rápidamente la asistencia del día actual\n'
              '• Los conteos de presentes, ausencias y total se muestran al inicio del historial'),
        ],
        icon: Icons.person,
      ),
      disableMovingAnimation: true,
      onBarrierClick: handleBarrierClick,
      onTargetClick: handleBarrierClick,
      disposeOnTap: false,
      child: child,
    );
  }

  void _onFinish() {
    _isAdvancing = false;
    _isRunning = false;
  }

  void dispose() {
    _isRunning = false;
    _showcaseView.unregister();
    _instance = null;
  }
}
