import 'package:flutter/material.dart';
import '../../../../shared/widgets/year_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final void Function(DateTime date) onDaySelected;

  const CalendarScreen({super.key, required this.onDaySelected});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentYear = DateTime.now().year;

  void _changeYear(int offset) {
    setState(() => _currentYear += offset);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left, size: 32),
                onPressed: () => _changeYear(-1),
              ),
              Text(
                '$_currentYear',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right, size: 32),
                onPressed: () => _changeYear(1),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: YearCalendar(
              year: _currentYear,
              today: now,
              onDayTap: widget.onDaySelected,
            ),
          ),
        ),
      ],
    );
  }
}
