import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/providers/shared_providers.dart';

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) => state = value;
}

final studentSearchProvider =
    NotifierProvider<SearchNotifier, String>(SearchNotifier.new);

final filteredStudentsProvider = FutureProvider<List<Student>>((ref) async {
  final dao = ref.watch(studentsDaoProvider);
  final query = ref.watch(studentSearchProvider);
  if (query.isEmpty) return dao.getAll();
  return dao.search(query);
});
