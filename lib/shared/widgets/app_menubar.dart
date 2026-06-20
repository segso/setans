import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum MenuItem {
  calendar,
  register,
  overview,
  tutorial,
  about,
}

extension MenuItemX on MenuItem {
  String get label {
    switch (this) {
      case MenuItem.calendar:
        return 'Calendario';
      case MenuItem.register:
        return 'Registro';
      case MenuItem.overview:
        return 'Vista general';
      case MenuItem.tutorial:
        return 'Tutorial';
      case MenuItem.about:
        return 'Acerca de';
    }
  }

  IconData get icon {
    switch (this) {
      case MenuItem.calendar:
        return Icons.calendar_month;
      case MenuItem.register:
        return Icons.people;
      case MenuItem.overview:
        return Icons.table_chart;
      case MenuItem.tutorial:
        return Icons.help_outline;
      case MenuItem.about:
        return Icons.info_outline;
    }
  }
}

class AppMenubar extends StatelessWidget {
  final MenuItem selected;
  final ValueChanged<MenuItem> onItemSelected;

  const AppMenubar({
    super.key,
    required this.selected,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SetansTheme.primary,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Setans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 32),
              ...MenuItem.values.map((item) => _MenuButton(
                    item: item,
                    isSelected: selected == item,
                    onTap: () => onItemSelected(item),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final MenuItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent;
    final textColor = isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: item == MenuItem.about ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 18, color: textColor),
                const SizedBox(width: 6),
                Text(
                  item.label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
