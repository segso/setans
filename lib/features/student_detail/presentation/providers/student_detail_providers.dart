import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';

final studentProvider = FutureProvider.family<Student?, int>((ref, id) async {
  final dao = ref.watch(studentsDaoProvider);
  return dao.getById(id);
});

final studentAssistancesProvider =
    FutureProvider.family<List<Assistance>, int>((ref, id) async {
  final dao = ref.watch(assistancesDaoProvider);
  return dao.getByStudent(id);
});
