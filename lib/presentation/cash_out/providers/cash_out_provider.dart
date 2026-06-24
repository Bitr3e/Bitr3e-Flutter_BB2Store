import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drift/drift.dart' hide Column;

import '../../../data/database/app_database.dart';
import '../../../data/models/cash_out.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../../data/repositories/cash_out_repository.dart';

class CashOutState {
  final List<CashOutEntry> entries;
  final DateTime selectedDate;
  final bool isLoading;

  const CashOutState({
    required this.entries,
    required this.selectedDate,
    this.isLoading = false,
  });

  int get totalCashOut {
    var total = 0;
    for (final e in entries) {
      total += e.amount;
    }
    return total;
  }

  CashOutState copyWith({
    List<CashOutEntry>? entries,
    DateTime? selectedDate,
    bool? isLoading,
  }) {
    return CashOutState(
      entries: entries ?? this.entries,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CashOutNotifier extends StateNotifier<CashOutState> {
  CashOutNotifier(this._ref)
      : super(CashOutState(
          entries: [],
          selectedDate: DateTime.now(),
          isLoading: true,
        )) {
    _load();
  }

  final Ref _ref;

  CashOutRepository get _repo => _ref.read(cashOutRepositoryProvider);

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    final dateOnly = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );
    final entries = await _repo.getByDate(dateOnly);
    state = state.copyWith(entries: entries, isLoading: false);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    _load();
  }

  Future<bool> addEntry({
    required int amount,
    required CashOutCategory category,
    required String? description,
  }) async {
    final dateOnly = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );

    final companion = CashOutEntriesCompanion(
      date: Value(dateOnly),
      amount: Value(amount),
      category: Value(category.name),
      description: Value(description),
    );

    await _repo.addCashOut(companion);
    await _load();
    return true;
  }

  Future<bool> updateEntry({
    required int id,
    required int amount,
    required CashOutCategory category,
    required String? description,
  }) async {
    final dateOnly = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
    );

    final companion = CashOutEntriesCompanion(
      date: Value(dateOnly),
      amount: Value(amount),
      category: Value(category.name),
      description: Value(description),
    );

    await _repo.updateCashOut(id, companion);
    await _load();
    return true;
  }

  Future<void> deleteEntry(int id) async {
    await _repo.deleteCashOut(id);
    await _load();
  }
}

final cashOutProvider =
    StateNotifierProvider<CashOutNotifier, CashOutState>((ref) {
  return CashOutNotifier(ref);
});
