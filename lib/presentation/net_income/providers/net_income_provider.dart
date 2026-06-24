import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/cash_out_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../settings/providers/settings_provider.dart';

class DenominationBreakdown {
  final int value;
  final int quantity;
  final int subtotal;

  const DenominationBreakdown({
    required this.value,
    required this.quantity,
    required this.subtotal,
  });
}

class NetIncomeData {
  final DateTime date;
  final List<DenominationBreakdown> denominations;
  final int grossIncome;
  final List<CashOutEntry> cashOutEntries;
  final int totalCashOut;
  final int dailyFundDeduction;
  final int netIncome;
  final bool hasData;

  const NetIncomeData({
    required this.date,
    required this.denominations,
    required this.grossIncome,
    required this.cashOutEntries,
    required this.totalCashOut,
    required this.dailyFundDeduction,
    required this.netIncome,
    required this.hasData,
  });
}

class NetIncomeNotifier extends StateNotifier<AsyncValue<NetIncomeData>> {
  NetIncomeNotifier(this._ref) : super(const AsyncLoading()) {
    _load(DateTime.now());
  }

  final Ref _ref;

  IncomeRepository get _incomeRepo => _ref.read(incomeRepositoryProvider);
  CashOutRepository get _cashOutRepo => _ref.read(cashOutRepositoryProvider);

  Future<void> _load(DateTime date) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _compute(date));
  }

  Future<NetIncomeData> _compute(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);

    final incomeRecord = await _incomeRepo.getByDate(dateOnly);
    final cashOuts = await _cashOutRepo.getByDate(dateOnly);

    final hasData = incomeRecord != null;

    final denominations = AppConstants.denominations.map((d) {
      int qty = 0;
      if (incomeRecord != null) {
        switch (d) {
          case 1: qty = incomeRecord.p1;
          case 5: qty = incomeRecord.p5;
          case 10: qty = incomeRecord.p10;
          case 20: qty = incomeRecord.p20;
          case 50: qty = incomeRecord.p50;
          case 100: qty = incomeRecord.p100;
          case 200: qty = incomeRecord.p200;
          case 500: qty = incomeRecord.p500;
          case 1000: qty = incomeRecord.p1000;
        }
      }
      return DenominationBreakdown(value: d, quantity: qty, subtotal: d * qty);
    }).toList();

    final gross = incomeRecord != null
        ? incomeRecord.p1 * 1 + incomeRecord.p5 * 5 + incomeRecord.p10 * 10 +
            incomeRecord.p20 * 20 + incomeRecord.p50 * 50 + incomeRecord.p100 * 100 +
            incomeRecord.p200 * 200 + incomeRecord.p500 * 500 + incomeRecord.p1000 * 1000
        : 0;

    final totalCashOut = cashOuts.fold(0, (sum, e) => sum + e.amount);
    final fund = _ref.read(settingsNotifierProvider).dailyFundAmount;
    final net = gross - totalCashOut - fund;

    return NetIncomeData(
      date: dateOnly,
      denominations: denominations,
      grossIncome: gross,
      cashOutEntries: cashOuts,
      totalCashOut: totalCashOut,
      dailyFundDeduction: fund,
      netIncome: net,
      hasData: hasData,
    );
  }

  void selectDate(DateTime date) {
    _load(date);
  }
}

final netIncomeProvider =
    StateNotifierProvider<NetIncomeNotifier, AsyncValue<NetIncomeData>>(
  (ref) => NetIncomeNotifier(ref),
);
