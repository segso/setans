import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.info_outline, color: SetansTheme.primary),
          const SizedBox(width: 8),
          const Text('Acerca de Setans'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Setans — Sistema de Asistencias',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
          Text('Desarrollado por [Tu Nombre]'),
          SizedBox(height: 8),
          Text('GitHub: github.com/tuusuario'),
          SizedBox(height: 8),
          Text('Email: tu@email.com'),
          SizedBox(height: 16),
          Text(
            'Sin número telefónico — contacte por los medios anteriores.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
