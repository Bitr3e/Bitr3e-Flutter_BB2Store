import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../../data/repositories/income_repository.dart';

class IncomeRecordingState {
  final Map<int, int> quantities;
  final bool isSaving;
  final bool isLoaded;
  final int? existingId;
  final String? errorMessage;

  const IncomeRecordingState({
    required this.quantities,
    this.isSaving = false,
    this.isLoaded = false,
    this.existingId,
    this.errorMessage,
  });

  int get grossIncome {
    var total = 0;
    for (final entry in quantities.entries) {
      total += entry.key * entry.value;
    }
    return total;
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
    bool clearError = false,
  }) {
    return IncomeRecordingState(
      quantities: quantities ?? this.quantities,
      isSaving: isSaving ?? this.isSaving,
      isLoaded: isLoaded ?? this.isLoaded,
      existingId: existingId ?? this.existingId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
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

  IncomeRepository get _repo => ref.read(incomeRepositoryProvider);

  Future<void> _loadToday() async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    final record = await _repo.getByDate(dateOnly);

    if (record != null) {
      state = state.copyWith(
        quantities: {
          AppConstants.denominations[0]: record.p1,
          AppConstants.denominations[1]: record.p5,
          AppConstants.denominations[2]: record.p10,
          AppConstants.denominations[3]: record.p20,
          AppConstants.denominations[4]: record.p50,
          AppConstants.denominations[5]: record.p100,
          AppConstants.denominations[6]: record.p200,
          AppConstants.denominations[7]: record.p500,
          AppConstants.denominations[8]: record.p1000,
        },
        isLoaded: true,
        existingId: record.id,
      );
    } else {
      state = state.copyWith(isLoaded: true);
    }
  }

  void updateQuantity(int denomination, int value) {
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

      await _repo.saveDailyIncome(companion);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save: $e',
      );
      return false;
    }
  }
}

final incomeRecordingProvider =
    NotifierProvider<IncomeRecordingNotifier, IncomeRecordingState>(
  IncomeRecordingNotifier.new,
);
