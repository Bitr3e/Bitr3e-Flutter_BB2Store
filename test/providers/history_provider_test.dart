import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bb2store_cash_inventory/data/database/app_database.dart';
import 'package:bb2store_cash_inventory/data/repositories/cash_out_repository.dart';
import 'package:bb2store_cash_inventory/data/repositories/income_repository.dart';
import 'package:bb2store_cash_inventory/domain/providers/database_provider.dart';
import 'package:bb2store_cash_inventory/domain/providers/repository_providers.dart';
import 'package:bb2store_cash_inventory/presentation/history/providers/history_provider.dart';

import '../test_helpers.dart';

void main() {
  group('HistoryNotifier', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = createInMemoryDb();
      container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          incomeRepositoryProvider.overrideWith(
            (ref) => IncomeRepository(ref.read(databaseProvider)),
          ),
          cashOutRepositoryProvider.overrideWith(
            (ref) => CashOutRepository(ref.read(databaseProvider)),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      db.close();
    });

    test('initial state is daily view with empty data', () {
      final state = container.read(historyProvider);
      expect(state.viewType, equals(HistoryViewType.daily));
    });

    test('loads income and cash-out data', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await seedIncome(db, date: DateTime(2026, 6, 25), p500: 2);
      await seedCashOut(db, date: DateTime(2026, 6, 24), amount: 300);

      await container.read(historyProvider.notifier).refresh();

      final state = container.read(historyProvider);
      expect(state.allIncome.length, equals(2));
      expect(state.allCashOuts.length, equals(1));
    });

    test('builds daily groups correctly', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await seedIncome(db, date: DateTime(2026, 6, 25), p500: 2);
      await seedCashOut(db, date: DateTime(2026, 6, 24), amount: 300);

      await container.read(historyProvider.notifier).refresh();

      final state = container.read(historyProvider);
      expect(state.groups.length, equals(2));
      expect(state.groups[0].label, contains('Jun 25'));
      expect(state.groups[1].label, contains('Jun 24'));
    });

    test('daily group calculates totals', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await seedCashOut(db, date: DateTime(2026, 6, 24), amount: 300);

      await container.read(historyProvider.notifier).refresh();

      final state = container.read(historyProvider);
      final jun24 = state.groups.firstWhere((g) => g.label.contains('24'));
      expect(jun24.totalGross, equals(5000));
      expect(jun24.totalCashOut, equals(300));
    });

    test('switching to weekly view groups correctly', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await container.read(historyProvider.notifier).refresh();
      container.read(historyProvider.notifier).setViewType(HistoryViewType.weekly);

      final state = container.read(historyProvider);
      expect(state.viewType, equals(HistoryViewType.weekly));
      expect(state.groups.length, greaterThan(0));
    });

    test('switching to monthly view groups correctly', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await container.read(historyProvider.notifier).refresh();
      container.read(historyProvider.notifier).setViewType(HistoryViewType.monthly);

      final state = container.read(historyProvider);
      expect(state.viewType, equals(HistoryViewType.monthly));
      expect(state.groups.length, greaterThan(0));
      expect(state.groups.first.label, equals('June'));
    });

    test('switching to yearly view groups correctly', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await container.read(historyProvider.notifier).refresh();
      container.read(historyProvider.notifier).setViewType(HistoryViewType.yearly);

      final state = container.read(historyProvider);
      expect(state.viewType, equals(HistoryViewType.yearly));
      expect(state.groups.length, greaterThan(0));
      expect(state.groups.first.label, equals('2026'));
    });

    test('search filters groups by label', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await seedIncome(db, date: DateTime(2026, 6, 25), p500: 2);
      await container.read(historyProvider.notifier).refresh();
      container.read(historyProvider.notifier).search('24');

      final state = container.read(historyProvider);
      expect(state.groups.length, equals(1));
      expect(state.groups.first.label, contains('24'));
    });

    test('search with no match returns empty', () async {
      await seedIncome(db, date: DateTime(2026, 6, 24), p1000: 5);
      await container.read(historyProvider.notifier).refresh();
      container.read(historyProvider.notifier).search('zzzz');

      final state = container.read(historyProvider);
      expect(state.groups, isEmpty);
    });
  });
}
