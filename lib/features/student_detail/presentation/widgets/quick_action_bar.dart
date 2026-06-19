import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../theme/app_theme.dart';
import '../providers/student_detail_providers.dart';

class QuickActionBar extends ConsumerWidget {
  final int studentId;

  const QuickActionBar({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return Column(
            children: [
              _Button(
                icon: Icons.check_circle_outline,
                label: 'Marcar presente hoy',
                color: SetansTheme.present,
                onPressed: () => _upsert(ref, DateTime.now(), 1),
              ),
              const SizedBox(height: 8),
              _Button(
                icon: Icons.cancel_outlined,
                label: 'Marcar ausente hoy',
                color: SetansTheme.absent,
                onPressed: () => _upsert(ref, DateTime.now(), 0),
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _Button(
                icon: Icons.check_circle_outline,
                label: 'Marcar presente hoy',
                color: SetansTheme.present,
                onPressed: () => _upsert(ref, DateTime.now(), 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Button(
                icon: Icons.cancel_outlined,
                label: 'Marcar ausente hoy',
                color: SetansTheme.absent,
                onPressed: () => _upsert(ref, DateTime.now(), 0),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _upsert(WidgetRef ref, DateTime date, int present) async {
    final dao = ref.read(assistancesDaoProvider);
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    await dao.upsert(
      AssistancesCompanion(
        studentId: Value(studentId),
        date: Value(dateStr),
        present: Value(present),
      ),
    );
    ref.read(quickActionStatusProvider.notifier).setStatus(present);
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _Button({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
