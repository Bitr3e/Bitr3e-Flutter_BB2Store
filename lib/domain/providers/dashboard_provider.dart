import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../presentation/dashboard/models/dashboard_data.dart';
import 'repository_providers.dart';

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

DateTime _startOfWeek(DateTime date) {
  final weekday = date.weekday;
  return _dateOnly(date).subtract(Duration(days: weekday - 1));
}

DateTime _endOfWeek(DateTime date) {
  return _startOfWeek(date).add(const Duration(days: 6));
}

DateTime _startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

DateTime _endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);

DateTime _startOfYear(DateTime date) => DateTime(date.year, 1, 1);

DateTime _endOfYear(DateTime date) => DateTime(date.year, 12, 31);

class DashboardNotifier extends AutoDisposeAsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async {
    return _load();
  }

  Future<DashboardData> _load() async {
    final incomeRepo = ref.read(incomeRepositoryProvider);
    final cashOutRepo = ref.read(cashOutRepositoryProvider);

    final now = DateTime.now();
    final today = _dateOnly(now);
    final yesterday = today.subtract(const Duration(days: 1));

    final weekStart = _startOfWeek(now);
    final weekEnd = _endOfWeek(now);
    final monthStart = _startOfMonth(now);
    final monthEnd = _endOfMonth(now);
    final yearStart = _startOfYear(now);
    final yearEnd = _endOfYear(now);

    final todayIncome = await incomeRepo.getByDate(today);
    final todayGross = todayIncome != null
        ? _computeGross(todayIncome)
        : 0;

    final todayCashOut = cashOutRepo.getTotalCashOutForDate(today);

    final yesterdayRecord = await incomeRepo.getByDate(yesterday);
    final yesterdayIncome = yesterdayRecord != null
        ? _computeGross(yesterdayRecord)
        : null;

    final highestRecord = await incomeRepo.getHighestIncome();
    final highestIncome = highestRecord != null
        ? _computeGross(highestRecord)
        : null;

    final lowestRecord = await incomeRepo.getLowestIncome();
    final lowestIncome = lowestRecord != null
        ? _computeGross(lowestRecord)
        : null;

    final weekIncome = await incomeRepo.getGrossIncomeForDateRange(
      weekStart,
      weekEnd,
    );
    final monthIncome = await incomeRepo.getGrossIncomeForDateRange(
      monthStart,
      monthEnd,
    );
    final yearIncome = await incomeRepo.getGrossIncomeForDateRange(
      yearStart,
      yearEnd,
    );

    final totalCashOut = await todayCashOut;

    const dailyFund = 300;
    final netIncome = todayGross - totalCashOut - dailyFund;

    return DashboardData(
      todayGrossIncome: todayGross,
      todayCashOut: totalCashOut,
      dailyFundDeduction: dailyFund,
      todayNetIncome: netIncome,
      yesterdayIncome: yesterdayIncome,
      highestIncome: highestIncome,
      lowestIncome: lowestIncome,
      weekIncome: weekIncome,
      monthIncome: monthIncome,
      yearIncome: yearIncome,
      hasData: todayIncome != null,
    );
  }

  int _computeGross(DailyIncomeRecord r) {
    return r.p1 * 1 +
        r.p5 * 5 +
        r.p10 * 10 +
        r.p20 * 20 +
        r.p50 * 50 +
        r.p100 * 100 +
        r.p200 * 200 +
        r.p500 * 500 +
        r.p1000 * 1000;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final dashboardProvider =
    AutoDisposeAsyncNotifierProvider<DashboardNotifier, DashboardData>(
  DashboardNotifier.new,
);
