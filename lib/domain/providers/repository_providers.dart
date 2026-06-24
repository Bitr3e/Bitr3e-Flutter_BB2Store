import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cash_out_repository.dart';
import '../../data/repositories/income_repository.dart';
import 'database_provider.dart';

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return IncomeRepository(db);
});

final cashOutRepositoryProvider = Provider<CashOutRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CashOutRepository(db);
});
