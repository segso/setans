import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';

final studentsDaoProvider = Provider((ref) => ref.watch(databaseProvider).studentsDao);

final assistancesDaoProvider = Provider((ref) => ref.watch(databaseProvider).assistancesDao);
