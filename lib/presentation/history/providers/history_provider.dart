import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/cash_out_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../domain/providers/repository_providers.dart';

enum HistoryViewType { daily, weekly, monthly, yearly }

class HistoryGroup {
  final String label;
  final String subtitle;
  final DateTime groupStart;
  final List<DailyIncomeRecord> incomeRecords;
  final List<CashOutEntry> cashOutEntries;
  final int totalGross;
  final int totalCashOut;
  final int netIncome;
  final double averageDaily;

  HistoryGroup({
    required this.label,
    required this.subtitle,
    required this.groupStart,
    required this.incomeRecords,
    required this.cashOutEntries,
    required this.totalGross,
    required this.totalCashOut,
    required this.netIncome,
    required this.averageDaily,
  });
}

class HistoryState {
  final HistoryViewType viewType;
  final List<DailyIncomeRecord> allIncome;
  final List<CashOutEntry> allCashOuts;
  final List<HistoryGroup> groups;
  final bool isLoading;
  final String searchQuery;

  const HistoryState({
    required this.viewType,
    required this.allIncome,
    required this.allCashOuts,
    required this.groups,
    this.isLoading = false,
    this.searchQuery = '',
  });

  HistoryState copyWith({
    HistoryViewType? viewType,
    List<DailyIncomeRecord>? allIncome,
    List<CashOutEntry>? allCashOuts,
    List<HistoryGroup>? groups,
    bool? isLoading,
    String? searchQuery,
  }) {
    return HistoryState(
      viewType: viewType ?? this.viewType,
      allIncome: allIncome ?? this.allIncome,
      allCashOuts: allCashOuts ?? this.allCashOuts,
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier(this._ref)
      : super(HistoryState(
          viewType: HistoryViewType.daily,
          allIncome: [],
          allCashOuts: [],
          groups: [],
          isLoading: true,
        )) {
    _load();
  }

  final Ref _ref;

  IncomeRepository get _incomeRepo => _ref.read(incomeRepositoryProvider);
  CashOutRepository get _cashOutRepo => _ref.read(cashOutRepositoryProvider);

  Future<void> _load() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true);
    final income = await _incomeRepo.getAll();
    if (!mounted) return;
    final cashOuts = await _cashOutRepo.getAll();
    if (!mounted) return;
    state = state.copyWith(
      allIncome: income,
      allCashOuts: cashOuts,
      isLoading: false,
    );
    _recomputeGroups();
  }

  void setViewType(HistoryViewType type) {
    if (type == state.viewType) return;
    state = state.copyWith(viewType: type);
    _recomputeGroups();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _recomputeGroups();
  }

  void _recomputeGroups() {
    List<HistoryGroup> groups;

    switch (state.viewType) {
      case HistoryViewType.daily:
        groups = _buildDailyGroups();
        break;
      case HistoryViewType.weekly:
        groups = _buildWeeklyGroups();
        break;
      case HistoryViewType.monthly:
        groups = _buildMonthlyGroups();
        break;
      case HistoryViewType.yearly:
        groups = _buildYearlyGroups();
        break;
    }

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      groups = groups
          .where((g) =>
              g.label.toLowerCase().contains(query) ||
              g.subtitle.toLowerCase().contains(query))
          .toList();
    }

    state = state.copyWith(groups: groups);
  }

  List<HistoryGroup> _buildDailyGroups() {
    final cashOutsByDate = <DateTime, List<CashOutEntry>>{};
    for (final c in state.allCashOuts) {
      final key = DateTime(c.date.year, c.date.month, c.date.day);
      cashOutsByDate.putIfAbsent(key, () => []).add(c);
    }

    return state.allIncome.map((record) {
      final date = record.date;
      final dateKey = DateTime(date.year, date.month, date.day);
      final dayCashOuts = cashOutsByDate[dateKey] ?? [];
      final gross = _computeGross(record);
      final cashOutTotal = dayCashOuts.fold(0, (sum, c) => sum + c.amount);
      const fund = 300;
      final net = gross - cashOutTotal - fund;
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final label = '${months[date.month - 1]} ${date.day}, ${date.year}';

      return HistoryGroup(
        label: label,
        subtitle: '${dayCashOuts.length} cash-out(s)',
        groupStart: date,
        incomeRecords: [record],
        cashOutEntries: dayCashOuts,
        totalGross: gross,
        totalCashOut: cashOutTotal,
        netIncome: net,
        averageDaily: gross.toDouble(),
      );
    }).toList();
  }

  List<HistoryGroup> _buildWeeklyGroups() {
    final weeks = <String, List<DailyIncomeRecord>>{};
    final weekCashOuts = <String, List<CashOutEntry>>{};

    for (final record in state.allIncome) {
      final weekKey = _weekKey(record.date);
      weeks.putIfAbsent(weekKey, () => []).add(record);
    }

    for (final c in state.allCashOuts) {
      final weekKey = _weekKey(c.date);
      weekCashOuts.putIfAbsent(weekKey, () => []).add(c);
    }

    return weeks.entries.map((entry) {
      final records = entry.value;
      final cOuts = weekCashOuts[entry.key] ?? [];
      final gross = records.fold(0, (sum, r) => sum + _computeGross(r));
      final cashOutTotal = cOuts.fold(0, (sum, c) => sum + c.amount);
      final fund = 300 * records.length;
      final net = gross - cashOutTotal - fund;
      final avg = records.isNotEmpty ? gross / records.length : 0.0;

      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final week = int.parse(parts[1]);
      final weekStart = _startOfWeek(year, week);
      final weekEnd = weekStart.add(const Duration(days: 6));
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

      return HistoryGroup(
        label: 'Week $week',
        subtitle: '${months[weekStart.month - 1]} ${weekStart.day} - ${months[weekEnd.month - 1]} ${weekEnd.day}, $year',
        groupStart: weekStart,
        incomeRecords: records,
        cashOutEntries: cOuts,
        totalGross: gross,
        totalCashOut: cashOutTotal,
        netIncome: net,
        averageDaily: avg,
      );
    }).toList()
      ..sort((a, b) => b.groupStart.compareTo(a.groupStart));
  }

  List<HistoryGroup> _buildMonthlyGroups() {
    final months = <String, List<DailyIncomeRecord>>{};
    final monthCashOuts = <String, List<CashOutEntry>>{};

    for (final record in state.allIncome) {
      final key = '${record.date.year}-${record.date.month}';
      months.putIfAbsent(key, () => []).add(record);
    }

    for (final c in state.allCashOuts) {
      final key = '${c.date.year}-${c.date.month}';
      monthCashOuts.putIfAbsent(key, () => []).add(c);
    }

    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return months.entries.map((entry) {
      final records = entry.value;
      final cOuts = monthCashOuts[entry.key] ?? [];
      final gross = records.fold(0, (sum, r) => sum + _computeGross(r));
      final cashOutTotal = cOuts.fold(0, (sum, c) => sum + c.amount);
      final fund = 300 * records.length;
      final net = gross - cashOutTotal - fund;
      final avg = records.isNotEmpty ? gross / records.length : 0.0;

      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      return HistoryGroup(
        label: monthNames[month - 1],
        subtitle: '$year',
        groupStart: DateTime(year, month, 1),
        incomeRecords: records,
        cashOutEntries: cOuts,
        totalGross: gross,
        totalCashOut: cashOutTotal,
        netIncome: net,
        averageDaily: avg,
      );
    }).toList()
      ..sort((a, b) => b.groupStart.compareTo(a.groupStart));
  }

  List<HistoryGroup> _buildYearlyGroups() {
    final years = <int, List<DailyIncomeRecord>>{};
    final yearCashOuts = <int, List<CashOutEntry>>{};

    for (final record in state.allIncome) {
      years.putIfAbsent(record.date.year, () => []).add(record);
    }

    for (final c in state.allCashOuts) {
      yearCashOuts.putIfAbsent(c.date.year, () => []).add(c);
    }

    return years.entries.map((entry) {
      final records = entry.value;
      final cOuts = yearCashOuts[entry.key] ?? [];
      final gross = records.fold(0, (sum, r) => sum + _computeGross(r));
      final cashOutTotal = cOuts.fold(0, (sum, c) => sum + c.amount);
      final fund = 300 * records.length;
      final net = gross - cashOutTotal - fund;
      final avg = records.isNotEmpty ? gross / records.length : 0.0;

      return HistoryGroup(
        label: entry.key.toString(),
        subtitle: '${records.length} records',
        groupStart: DateTime(entry.key, 1, 1),
        incomeRecords: records,
        cashOutEntries: cOuts,
        totalGross: gross,
        totalCashOut: cashOutTotal,
        netIncome: net,
        averageDaily: avg,
      );
    }).toList()
      ..sort((a, b) => b.groupStart.compareTo(a.groupStart));
  }

  String _weekKey(DateTime date) {
    final weekOfYear = _isoWeekNumber(date);
    return '${date.year}-$weekOfYear';
  }

  int _isoWeekNumber(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final jan1 = DateTime(thursday.year, 1, 1);
    final days = thursday.difference(jan1).inDays;
    return ((days + jan1.weekday - 1) / 7).ceil();
  }

  DateTime _startOfWeek(int year, int week) {
    final jan4 = DateTime(year, 1, 4);
    final daysToThursday = 4 - jan4.weekday;
    final firstThursday = jan4.add(Duration(days: daysToThursday));
    return firstThursday
        .add(Duration(days: (week - 1) * 7 - 3));
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

final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier(ref);
});
