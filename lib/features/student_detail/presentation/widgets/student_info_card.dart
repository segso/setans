import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../theme/app_theme.dart';

class StudentInfoCard extends StatefulWidget {
  final Student student;
  final Future<void> Function(String name, String major, String shift) onSaved;

  const StudentInfoCard({
    super.key,
    required this.student,
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
    'Contabilidad',
    'Inteligencia artificial',
    'Laboratorista químico',
    'Mecánica industrial',
    'Mecatrónica',
    'Programación',
    'Soporte',
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
                Expanded(
                  child: Text(
                    'Estudiante: ${s.id}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(_editing ? Icons.close : Icons.edit),
                  onPressed: () => setState(() => _editing = !_editing),
                ),
              ],
            ),
            const Divider(),
            if (_editing) _buildEditMode() else _buildViewMode(s),
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
    final labelWidth = MediaQuery.of(context).size.width < 500 ? 90.0 : 120.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}


