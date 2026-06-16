import 'package:flutter/material.dart';

class FuzzySearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const FuzzySearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Buscar...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        isDense: true,
      ),
    );
  }
}
