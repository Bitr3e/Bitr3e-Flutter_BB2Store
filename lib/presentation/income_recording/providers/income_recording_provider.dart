import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/cash_out_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../../domain/providers/dashboard_provider.dart';
import '../../history/providers/history_provider.dart';
import '../../settings/providers/settings_provider.dart';

class IncomeRecordingState {
  final Map<int, int> quantities;
  final bool isSaving;
  final bool isLoaded;
  final int? existingId;
  final String? errorMessage;
  final List<CashOutEntry> todayCashOuts;
  final int dailyFundAmount;
  final bool isLocked;

  const IncomeRecordingState({
    required this.quantities,
    this.isSaving = false,
    this.isLoaded = false,
    this.existingId,
    this.errorMessage,
    this.todayCashOuts = const [],
    this.dailyFundAmount = 300,
    this.isLocked = false,
  });

  int get grossIncome {
    var total = 0;
    for (final entry in quantities.entries) {
      total += entry.key * entry.value;
    }
    return total;
  }

  int get totalCashOut {
    var total = 0;
    for (final e in todayCashOuts) {
      total += e.amount;
    }
    return total;
  }

  int get netIncome {
    return grossIncome + totalCashOut - dailyFundAmount;
  }

  bool get isValid {
    return quantities.values.every((q) => q >= 0);
  }

  IncomeRecordingState copyWith({
    Map<int, int>? quantities,
    bool? isSaving,
    bool? isLoaded,
    int? existingId,
    String? errorMessage,
    List<CashOutEntry>? todayCashOuts,
    int? dailyFundAmount,
    bool? isLocked,
    bool clearError = false,
  }) {
    return IncomeRecordingState(
      quantities: quantities ?? this.quantities,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      existingId: existingId ?? this.existingId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      todayCashOuts: todayCashOuts ?? this.todayCashOuts,
      dailyFundAmount: dailyFundAmount ?? this.dailyFundAmount,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class IncomeRecordingNotifier extends Notifier<IncomeRecordingState> {
  @override
  IncomeRecordingState build() {
    _loadToday();
    return IncomeRecordingState(
      quantities: {
        for (final d in AppConstants.denominations) d: 0,
      },
    );
  }

  IncomeRepository get _incomeRepo => ref.read(incomeRepositoryProvider);
  CashOutRepository get _cashOutRepo => ref.read(cashOutRepositoryProvider);

  Future<void> _loadToday() async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    final settings = ref.read(settingsNotifierProvider);
    final record = await _incomeRepo.getByDate(dateOnly);

    if (record != null) {
      state = state.copyWith(
        isLoaded: true,
        existingId: record.id,
        todayCashOuts: const [],
        isLocked: true,
        dailyFundAmount: settings.dailyFundAmount,
      );
    } else {
      final cashOuts = await _cashOutRepo.getByDate(dateOnly);
      state = state.copyWith(
        todayCashOuts: cashOuts,
        dailyFundAmount: settings.dailyFundAmount,
        isLoaded: true,
        isLocked: false,
      );
    }
  }

  void updateQuantity(int denomination, int value) {
    if (state.isLocked) return;
    if (value < 0) return;
    final newQuantities = Map<int, int>.from(state.quantities);
    newQuantities[denomination] = value;
    state = state.copyWith(quantities: newQuantities, clearError: true);
  }

  Future<bool> save() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Invalid quantities');
      return false;
    }

    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final today = DateTime.now();
      final dateOnly = DateTime(today.year, today.month, today.day);

      final q = state.quantities;

      final companion = DailyIncomeRecordsCompanion(
        date: Value(dateOnly),
        p1: Value(q[1] ?? 0),
        p5: Value(q[5] ?? 0),
        p10: Value(q[10] ?? 0),
        p20: Value(q[20] ?? 0),
        p50: Value(q[50] ?? 0),
        p100: Value(q[100] ?? 0),
        p200: Value(q[200] ?? 0),
        p500: Value(q[500] ?? 0),
        p1000: Value(q[1000] ?? 0),
      );

      await _incomeRepo.saveDailyIncome(companion);

      state = state.copyWith(
        isSaving: false,
        quantities: {
          for (final d in AppConstants.denominations) d: 0,
        },
        todayCashOuts: const [],
        isLocked: true,
      );

      ref.invalidate(dashboardProvider);
      ref.read(historyProvider.notifier).refresh();

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save: $e',
      );
      return false;
    }
  }

  Future<void> deleteCashOut(int id) async {
    if (state.isLocked) return;
    await _cashOutRepo.deleteCashOut(id);
    await refresh();
    ref.invalidate(dashboardProvider);
    ref.read(historyProvider.notifier).refresh();
  }

  Future<void> refresh() async {
    await _loadToday();
  }
}

final incomeRecordingProvider =
    NotifierProvider<IncomeRecordingNotifier, IncomeRecordingState>(
  IncomeRecordingNotifier.new,
);
