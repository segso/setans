import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class YearCalendar extends StatelessWidget {
  final int year;
  final DateTime today;
  final void Function(DateTime date)? onDayTap;
  final Set<DateTime>? highlightedDays;

  const YearCalendar({
    super.key,
    required this.year,
    required this.today,
    this.onDayTap,
    this.highlightedDays,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth >= 800) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 400) {
          crossAxisCount = 2;
        }

        final rows = <List<int>>[];
        for (int i = 1; i <= 12; i += crossAxisCount) {
          final end = (i + crossAxisCount > 12) ? 13 : i + crossAxisCount;
          rows.add(List.generate(end - i, (index) => i + index));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: rows.length,
          itemBuilder: (context, rowIndex) {
            final monthRow = rows[rowIndex];

            int maxWeeksInRow = 0;
            for (final month in monthRow) {
              final weeks = _calculateWeeksInMonth(year, month);
              if (weeks > maxWeeksInRow) maxWeeksInRow = weeks;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...monthRow.map((month) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _MonthCard(
                            year: year,
                            month: month,
                            totalWeeksHeight: maxWeeksInRow,
                            today: today,
                            onDayTap: onDayTap,
                            highlightedDays: highlightedDays,
                          ),
                        ),
                      )),
                  ...List.generate(
                    crossAxisCount - monthRow.length,
                    (_) => const Expanded(child: SizedBox()),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int _calculateWeeksInMonth(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final leadingDays = firstDayOfMonth.weekday % 7;
    final totalSlots = leadingDays + lastDayOfMonth.day;
    return (totalSlots / 7).ceil();
  }
}

class _MonthCard extends StatelessWidget {
  final int year;
  final int month;
  final int totalWeeksHeight;
  final DateTime today;
  final void Function(DateTime date)? onDayTap;
  final Set<DateTime>? highlightedDays;

  const _MonthCard({
    required this.year,
    required this.month,
    required this.totalWeeksHeight,
    required this.today,
    this.onDayTap,
    this.highlightedDays,
  });

  static const _monthNames = [
    '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  static const _weekDays = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingSlots = firstDay.weekday % 7;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _monthNames[month],
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekDays
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const Divider(height: 12),
            Column(
              children: List.generate(totalWeeksHeight, (weekIndex) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final slotIndex = (weekIndex * 7) + dayIndex;
                      final dayNumber = slotIndex - leadingSlots + 1;

                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        return const Expanded(child: SizedBox(height: 32));
                      }

                      final date = DateTime(year, month, dayNumber);
                      final isSaturday = dayIndex == 6;
                      final isToday = date.year == today.year &&
                          date.month == today.month &&
                          date.day == today.day;
                      final isHighlighted = highlightedDays?.contains(date) ?? false;

                      BoxDecoration? decoration;
                      TextStyle textStyle = const TextStyle(fontSize: 13);

                      if (isToday) {
                        decoration = BoxDecoration(
                          color: SetansTheme.primary,
                          shape: BoxShape.circle,
                        );
                        textStyle = const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        );
                      } else if (isHighlighted) {
                        decoration = BoxDecoration(
                          color: SetansTheme.present.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        );
                        textStyle = TextStyle(
                          color: SetansTheme.present,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        );
                      } else if (isSaturday) {
                        decoration = BoxDecoration(
                          color: SetansTheme.saturdayBg,
                          borderRadius: BorderRadius.circular(6),
                        );
                        textStyle = const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        );
                      }

                      return Expanded(
                        child: InkWell(
                          onTap: onDayTap != null ? () => onDayTap!(date) : null,
                          borderRadius: isToday ? null : BorderRadius.circular(6),
                          child: Container(
                            height: 32,
                            alignment: Alignment.center,
                            decoration: decoration,
                            child: Text('$dayNumber', style: textStyle),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
