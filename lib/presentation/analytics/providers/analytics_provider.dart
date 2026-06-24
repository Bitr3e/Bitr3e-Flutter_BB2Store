import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../domain/providers/repository_providers.dart';

class ComparisonData {
  final int current;
  final int previous;
  final int difference;
  final double percentageChange;

  ComparisonData({
    required this.current,
    required this.previous,
  })  : difference = current - previous,
        percentageChange = previous > 0
            ? ((current - previous) / previous) * 100
            : current > 0 ? 100 : 0;
}

class AnalyticsData {
  final bool hasData;

  final int highestIncome;
  final int lowestIncome;
  final double averageDailyIncome;
  final double averageMonthlyIncome;
  final int yearTotalIncome;

  final ComparisonData todayVsYesterday;
  final ComparisonData thisWeekVsLastWeek;
  final ComparisonData thisMonthVsLastMonth;

  AnalyticsData({
    required this.hasData,
    required this.highestIncome,
    required this.lowestIncome,
    required this.averageDailyIncome,
    required this.averageMonthlyIncome,
    required this.yearTotalIncome,
    required this.todayVsYesterday,
    required this.thisWeekVsLastWeek,
    required this.thisMonthVsLastMonth,
  });
}

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsData>> {
  AnalyticsNotifier(this._ref) : super(const AsyncLoading()) {
    _load();
  }

  final Ref _ref;

  IncomeRepository get _incomeRepo => _ref.read(incomeRepositoryProvider);

  Future<void> _load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _compute());
  }

  Future<AnalyticsData> _compute() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final lastWeekStart = weekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = weekStart.subtract(const Duration(days: 1));

    final monthStart = DateTime(today.year, today.month, 1);
    final lastMonthEnd = monthStart.subtract(const Duration(days: 1));
    final lastMonthStart = DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);

    final allIncome = await _incomeRepo.getAll();

    if (allIncome.isEmpty) {
      return AnalyticsData(
        hasData: false,
        highestIncome: 0,
        lowestIncome: 0,
        averageDailyIncome: 0,
        averageMonthlyIncome: 0,
        yearTotalIncome: 0,
        todayVsYesterday: ComparisonData(current: 0, previous: 0),
        thisWeekVsLastWeek: ComparisonData(current: 0, previous: 0),
        thisMonthVsLastMonth: ComparisonData(current: 0, previous: 0),
      );
    }

    final recordsWithGross = allIncome
        .map((r) => (record: r, gross: _computeGross(r)))
        .toList();

    final highest = recordsWithGross
        .reduce((a, b) => a.gross >= b.gross ? a : b)
        .gross;
    final lowest = recordsWithGross
        .reduce((a, b) => a.gross <= b.gross ? a : b)
        .gross;

    final totalIncome =
        recordsWithGross.fold(0, (sum, r) => sum + r.gross);
    final dayCount = allIncome.length;
    final monthKeys = <String>{};
    for (final r in allIncome) {
      monthKeys.add('${r.date.year}-${r.date.month}');
    }
    final monthCount = monthKeys.length;

    final avgDaily =
        dayCount > 0 ? totalIncome / dayCount : 0.0;
    final avgMonthly =
        monthCount > 0 ? totalIncome / monthCount : 0.0;

    final yearIncome = recordsWithGross
        .where((r) => r.record.date.year == now.year)
        .fold(0, (sum, r) => sum + r.gross);

    final todayRecord = allIncome.where((r) {
      final d = DateTime(r.date.year, r.date.month, r.date.day);
      return d == today;
    }).toList();
    final todayGross = todayRecord.isNotEmpty
        ? _computeGross(todayRecord.first)
        : 0;

    final yesterdayRecord = allIncome.where((r) {
      final d = DateTime(r.date.year, r.date.month, r.date.day);
      return d == yesterday;
    }).toList();
    final yesterdayGross = yesterdayRecord.isNotEmpty
        ? _computeGross(yesterdayRecord.first)
        : 0;

    final weekIncome = recordsWithGross
        .where((r) =>
            r.record.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            r.record.date.isBefore(weekStart.add(const Duration(days: 7))))
        .fold(0, (sum, r) => sum + r.gross);

    final lastWeekIncome = recordsWithGross
        .where((r) =>
            r.record.date.isAfter(lastWeekStart.subtract(const Duration(days: 1))) &&
            r.record.date.isBefore(lastWeekEnd.add(const Duration(days: 1))))
        .fold(0, (sum, r) => sum + r.gross);

    final monthIncome = recordsWithGross
        .where((r) => r.record.date.month == now.month && r.record.date.year == now.year)
        .fold(0, (sum, r) => sum + r.gross);

    final lastMonthIncome = recordsWithGross
        .where((r) =>
            r.record.date.month == lastMonthStart.month &&
            r.record.date.year == lastMonthStart.year)
        .fold(0, (sum, r) => sum + r.gross);

    return AnalyticsData(
      hasData: true,
      highestIncome: highest,
      lowestIncome: lowest,
      averageDailyIncome: avgDaily,
      averageMonthlyIncome: avgMonthly,
      yearTotalIncome: yearIncome,
      todayVsYesterday: ComparisonData(
        current: todayGross,
        previous: yesterdayGross,
      ),
      thisWeekVsLastWeek: ComparisonData(
        current: weekIncome,
        previous: lastWeekIncome,
      ),
      thisMonthVsLastMonth: ComparisonData(
        current: monthIncome,
        previous: lastMonthIncome,
      ),
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
    await _load();
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsData>>(
  (ref) => AnalyticsNotifier(ref),
);
