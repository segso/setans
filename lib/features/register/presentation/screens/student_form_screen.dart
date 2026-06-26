import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';
import '../../../../theme/app_theme.dart';

const _majors = [
  'Contabilidad',
  'Inteligencia artificial',
  'Laboratorista químico',
  'Mecánica industrial',
  'Mecatrónica',
  'Programación',
  'Soporte',
];

const _shifts = ['Matutino', 'Vespertino'];

class StudentFormScreen extends ConsumerStatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  String _selectedMajor = _majors[0];
  String _selectedShift = _shifts[0];
  bool _saving = false;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    _idController = TextEditingController(text: s?.id.toString() ?? '');
    _nameController = TextEditingController(text: s?.name ?? '');
    if (s != null) {
      _selectedMajor = s.major;
      _selectedShift = s.shift;
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final dao = ref.read(studentsDaoProvider);
      final companion = StudentsCompanion(
        id: drift.Value(int.parse(_idController.text.trim())),
        name: drift.Value(_nameController.text.trim()),
        major: drift.Value(_selectedMajor),
        shift: drift.Value(_selectedShift),
        createdAt: drift.Value(
          widget.student?.createdAt ?? DateTime.now().toIso8601String(),
        ),
      );

      if (_isEditing) {
        await dao.updateStudent(companion);
      } else {
        await dao.insert(companion);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: SetansTheme.absent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Editar estudiante' : 'Nuevo estudiante';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID numérico',
                  hintText: 'Ej: 2024001',
                ),
                keyboardType: TextInputType.number,
                readOnly: _isEditing,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser numérico';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 32),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isEditing ? 'Actualizar' : 'Crear'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
