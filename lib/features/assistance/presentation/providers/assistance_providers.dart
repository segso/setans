import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';

class AssistanceSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final assistanceSearchProvider =
    NotifierProvider<AssistanceSearchNotifier, String>(
        AssistanceSearchNotifier.new);

class DayAssistanceOverrideNotifier extends Notifier<Map<int, int>> {
  @override
  Map<int, int> build() => {};

  void setOverride(int studentId, int present) {
    state = {...state, studentId: present};
  }

  void clear() => state = {};
}

final dayAssistanceOverrideProvider =
    NotifierProvider<DayAssistanceOverrideNotifier, Map<int, int>>(
        DayAssistanceOverrideNotifier.new);

final filteredDayStudentsProvider = FutureProvider<List<Student>>((ref) async {
  ref.watch(mutationProvider);
  final dao = ref.watch(studentsDaoProvider);
  final query = ref.watch(assistanceSearchProvider);
  if (query.isEmpty) return dao.getAll();
  return dao.search(query);
});

final dayAssistanceProvider =
    FutureProvider.family<Map<int, Assistance>, DateTime>((ref, date) async {
  ref.watch(mutationProvider);
  final dao = ref.watch(assistancesDaoProvider);
  final dateStr =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final list = await dao.getByDate(dateStr);
  return {for (final a in list) a.studentId: a};
});
