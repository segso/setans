import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';

final studentsDaoProvider = Provider((ref) => ref.watch(databaseProvider).studentsDao);

final assistancesDaoProvider = Provider((ref) => ref.watch(databaseProvider).assistancesDao);

class MutationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state = state + 1;
}

final mutationProvider = NotifierProvider<MutationNotifier, int>(MutationNotifier.new);
