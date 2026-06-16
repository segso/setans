import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../theme/app_theme.dart';

class StudentInfoCard extends StatefulWidget {
  final Student student;
  final List<Assistance> assistances;
  final Future<void> Function(String name, String major, String shift) onSaved;

  const StudentInfoCard({
    super.key,
    required this.student,
    required this.assistances,
    required this.onSaved,
  });

  @override
  State<StudentInfoCard> createState() => _StudentInfoCardState();
}

class _StudentInfoCardState extends State<StudentInfoCard> {
  late final TextEditingController _nameController;
  late String _selectedMajor;
  late String _selectedShift;
  bool _editing = false;
  bool _saving = false;

  static const _majors = [
    'Laboratorista químico',
    'Mecatrónica',
    'Programación',
    'Mecánica industrial',
    'Inteligencia artificial',
    'Contabilidad',
  ];

  static const _shifts = ['Matutino', 'Vespertino'];

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _nameController = TextEditingController(text: s.name);
    _selectedMajor = s.major;
    _selectedShift = s.shift;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSaved(
        _nameController.text.trim(),
        _selectedMajor,
        _selectedShift,
      );
      if (mounted) setState(() => _editing = false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final total = widget.assistances.length;
    final present = widget.assistances.where((a) => a.present == 1).length;
    final absent = total - present;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 32, color: SetansTheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Estudiante: ${s.id}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_editing ? Icons.close : Icons.edit),
                  onPressed: () => setState(() => _editing = !_editing),
                ),
              ],
            ),
            const Divider(),
            if (_editing) _buildEditMode() else _buildViewMode(s),
            const Divider(),
            Row(
              children: [
                _StatBadge(
                  label: 'Asistencias',
                  count: present,
                  color: SetansTheme.present,
                ),
                const SizedBox(width: 16),
                _StatBadge(
                  label: 'Faltas',
                  count: absent,
                  color: SetansTheme.absent,
                ),
                const SizedBox(width: 16),
                _StatBadge(
                  label: 'Total',
                  count: total,
                  color: SetansTheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMode(Student s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Nombre', value: s.name),
        _InfoRow(label: 'Especialidad', value: s.major),
        _InfoRow(label: 'Turno', value: s.shift),
        _InfoRow(label: 'Registrado', value: s.createdAt),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _selectedMajor,
          decoration: const InputDecoration(labelText: 'Especialidad'),
          items: _majors
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedMajor = v);
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _selectedShift,
          decoration: const InputDecoration(labelText: 'Turno'),
          items: _shifts
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedShift = v);
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
