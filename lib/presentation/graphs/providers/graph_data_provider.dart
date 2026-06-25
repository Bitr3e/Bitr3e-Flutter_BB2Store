import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/cash_out_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../domain/providers/repository_providers.dart';

class DailyChartPoint {
  final DateTime date;
  final int gross;
  final int net;

  DailyChartPoint({required this.date, required this.gross, required this.net});
}

class WeeklyChartPoint {
  final String label;
  final int weekNumber;
  final int year;
  final int gross;

  WeeklyChartPoint({
    required this.label,
    required this.weekNumber,
    required this.year,
    required this.gross,
  });
}

class MonthlyChartPoint {
  final String label;
  final int month;
  final int year;
  final int gross;
  final int cashOut;
  final int net;

  MonthlyChartPoint({
    required this.label,
    required this.month,
    required this.year,
    required this.gross,
    required this.cashOut,
    required this.net,
  });
}

class YearlyChartPoint {
  final int year;
  final int gross;
  final int net;

  YearlyChartPoint({required this.year, required this.gross, required this.net});
}

class GraphData {
  final List<DailyChartPoint> dailyPoints;
  final List<WeeklyChartPoint> weeklyPoints;
  final List<MonthlyChartPoint> monthlyPoints;
  final List<YearlyChartPoint> yearlyPoints;
  final bool hasData;

  GraphData({
    required this.dailyPoints,
    required this.weeklyPoints,
    required this.monthlyPoints,
    required this.yearlyPoints,
    required this.hasData,
  });
}

class GraphDataNotifier extends StateNotifier<AsyncValue<GraphData>> {
  GraphDataNotifier(this._ref) : super(const AsyncLoading()) {
    _load();
  }

  final Ref _ref;

  IncomeRepository get _incomeRepo => _ref.read(incomeRepositoryProvider);
  CashOutRepository get _cashOutRepo => _ref.read(cashOutRepositoryProvider);

  Future<void> _load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _compute());
  }

  Future<GraphData> _compute() async {
    final allIncome = await _incomeRepo.getAll();
    final allCashOuts = await _cashOutRepo.getAll();

    if (allIncome.isEmpty) {
      return GraphData(
        dailyPoints: [],
        weeklyPoints: [],
        monthlyPoints: [],
        yearlyPoints: [],
        hasData: false,
      );
    }

    final sorted = List<DailyIncomeRecord>.from(allIncome)
      ..sort((a, b) => a.date.compareTo(b.date));

    final cashOutByDate = <DateTime, int>{};
    for (final c in allCashOuts) {
      final key = DateTime(c.date.year, c.date.month, c.date.day);
      cashOutByDate[key] = (cashOutByDate[key] ?? 0) + c.amount;
    }

    final dailyPoints = sorted.map((r) {
      final date = DateTime(r.date.year, r.date.month, r.date.day);
      final gross = _gross(r);
      final cashOut = cashOutByDate[date] ?? 0;
      return DailyChartPoint(
        date: date,
        gross: gross,
        net: gross + cashOut - 300,
      );
    }).toList();

    final weeklyMap = <String, List<DailyIncomeRecord>>{};
    for (final r in sorted) {
      final wk = _weekKey(r.date);
      weeklyMap.putIfAbsent(wk, () => []).add(r);
    }
    final weeklyPoints = weeklyMap.entries.map((e) {
      final parts = e.key.split('-');
      final year = int.parse(parts[0]);
      final weekNum = int.parse(parts[1]);
      final gross = e.value.fold(0, (sum, r) => sum + _gross(r));
      return WeeklyChartPoint(
        label: 'W$weekNum',
        weekNumber: weekNum,
        year: year,
        gross: gross,
      );
    }).toList()
      ..sort((a, b) => a.year != b.year
          ? a.year.compareTo(b.year)
          : a.weekNumber.compareTo(b.weekNumber));

    final monthMap = <String, List<DailyIncomeRecord>>{};
    for (final r in sorted) {
      final key = '${r.date.year}-${r.date.month}';
      monthMap.putIfAbsent(key, () => []).add(r);
    }
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final monthlyPoints = monthMap.entries.map((e) {
      final parts = e.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final records = e.value;
      final gross = records.fold(0, (sum, r) => sum + _gross(r));
      final cashOut = records.fold(0, (sum, r) {
        final date = DateTime(r.date.year, r.date.month, r.date.day);
        return sum + (cashOutByDate[date] ?? 0);
      });
      final net = gross + cashOut - (300 * records.length);
      return MonthlyChartPoint(
        label: monthNames[month - 1],
        month: month,
        year: year,
        gross: gross,
        cashOut: cashOut,
        net: net,
      );
    }).toList()
      ..sort((a, b) => a.year != b.year
          ? a.year.compareTo(b.year)
          : a.month.compareTo(b.month));

    final yearMap = <int, List<DailyIncomeRecord>>{};
    for (final r in sorted) {
      yearMap.putIfAbsent(r.date.year, () => []).add(r);
    }
    final yearlyPoints = yearMap.entries.map((e) {
      final gross = e.value.fold(0, (sum, r) => sum + _gross(r));
      return YearlyChartPoint(year: e.key, gross: gross, net: gross);
    }).toList()
      ..sort((a, b) => a.year.compareTo(b.year));

    return GraphData(
      dailyPoints: dailyPoints,
      weeklyPoints: weeklyPoints,
      monthlyPoints: monthlyPoints,
      yearlyPoints: yearlyPoints,
      hasData: true,
    );
  }

  int _gross(DailyIncomeRecord r) {
    return r.p1 * 1 + r.p5 * 5 + r.p10 * 10 + r.p20 * 20 +
        r.p50 * 50 + r.p100 * 100 + r.p200 * 200 +
        r.p500 * 500 + r.p1000 * 1000;
  }

  String _weekKey(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final jan1 = DateTime(thursday.year, 1, 1);
    final days = thursday.difference(jan1).inDays;
    final week = ((days + jan1.weekday - 1) / 7).ceil();
    return '${date.year}-$week';
  }

  Future<void> refresh() async {
    await _load();
  }
}

final graphDataProvider =
    StateNotifierProvider<GraphDataNotifier, AsyncValue<GraphData>>(
  (ref) => GraphDataNotifier(ref),
);
