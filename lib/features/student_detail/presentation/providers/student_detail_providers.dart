import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';

final studentProvider = FutureProvider.family<Student?, int>((ref, id) async {
  ref.watch(mutationProvider);
  final dao = ref.watch(studentsDaoProvider);
  return dao.getById(id);
});

final studentAssistancesProvider =
    FutureProvider.family<List<Assistance>, int>((ref, id) async {
  ref.watch(mutationProvider);
  final dao = ref.watch(assistancesDaoProvider);
  return dao.getByStudent(id);
});

final totalDatesProvider = FutureProvider<int>((ref) async {
  ref.watch(mutationProvider);
  final dao = ref.watch(assistancesDaoProvider);
  final dates = await dao.getDatesWithRegistries();
  return dates.length;
});

final allDatesProvider = FutureProvider<List<String>>((ref) async {
  ref.watch(mutationProvider);
  final dao = ref.watch(assistancesDaoProvider);
  return dao.getDatesWithRegistries();
});

class QuickActionStatusNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setStatus(int? status) => state = status;
}

final quickActionStatusProvider =
    NotifierProvider<QuickActionStatusNotifier, int?>(QuickActionStatusNotifier.new);
