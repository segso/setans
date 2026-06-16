import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class DayAssistanceScreen extends StatelessWidget {
  final DateTime date;

  const DayAssistanceScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.day}/${date.month}/${date.year}';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_calendar, size: 64, color: SetansTheme.primaryLight),
            const SizedBox(height: 16),
            Text(
              'Asistencia del $formatted',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Próximamente en la Fase 3',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
