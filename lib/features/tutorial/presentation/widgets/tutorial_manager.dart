import 'package:flutter/material.dart';

class TutorialManager {
  static final GlobalKey calendarKey = GlobalKey();
  static final GlobalKey registerKey = GlobalKey();
  static final GlobalKey overviewKey = GlobalKey();
  static final GlobalKey aboutKey = GlobalKey();

  void startTutorial(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tutorial'),
        content: const Text(
          'Guía interactiva paso a paso disponible en Fase 4.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
