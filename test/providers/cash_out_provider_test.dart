import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bb2store_cash_inventory/data/database/app_database.dart';
import 'package:bb2store_cash_inventory/data/models/cash_out.dart';
import 'package:bb2store_cash_inventory/data/repositories/cash_out_repository.dart';
import 'package:bb2store_cash_inventory/domain/providers/database_provider.dart';
import 'package:bb2store_cash_inventory/domain/providers/repository_providers.dart';
import 'package:bb2store_cash_inventory/presentation/cash_out/providers/cash_out_provider.dart';

import '../test_helpers.dart';

void main() {
  group('CashOutNotifier', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = createInMemoryDb();
      container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
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

    test('initial state has empty entries and mounts', () {
      final state = container.read(cashOutProvider);
      expect(state.entries, isEmpty);
    });

    test('addEntry creates a new cash-out entry', () async {
      final notifier = container.read(cashOutProvider.notifier);
      final success = await notifier.addEntry(
        amount: 500,
        category: CashOutCategory.storeExpenses,
        description: 'Test expense',
      );
      expect(success, isTrue);

      final state = container.read(cashOutProvider);
      expect(state.entries.length, equals(1));
      expect(state.entries.first.amount, equals(500));
    });

    test('addEntry without description', () async {
      final notifier = container.read(cashOutProvider.notifier);
      await notifier.addEntry(
        amount: 300,
        category: CashOutCategory.miscellaneous,
        description: null,
      );

      final state = container.read(cashOutProvider);
      expect(state.entries.length, equals(1));
      expect(state.entries.first.description, isNull);
    });

    test('totalCashOut sums entries', () async {
      final notifier = container.read(cashOutProvider.notifier);
      await notifier.addEntry(amount: 200, category: CashOutCategory.storeExpenses, description: null);
      await notifier.addEntry(amount: 300, category: CashOutCategory.miscellaneous, description: null);

      final state = container.read(cashOutProvider);
      expect(state.totalCashOut, equals(500));
    });

    test('empty entries has totalCashOut of 0', () {
      final state = container.read(cashOutProvider);
      expect(state.totalCashOut, equals(0));
    });

    test('deleteEntry removes entry', () async {
      final notifier = container.read(cashOutProvider.notifier);
      await notifier.addEntry(amount: 100, category: CashOutCategory.supplierPayment, description: null);

      var state = container.read(cashOutProvider);
      final id = state.entries.first.id;

      await notifier.deleteEntry(id);
      state = container.read(cashOutProvider);
      expect(state.entries, isEmpty);
    });

    test('updateEntry modifies existing entry', () async {
      final notifier = container.read(cashOutProvider.notifier);
      await notifier.addEntry(amount: 100, category: CashOutCategory.storeExpenses, description: 'Old');

      var state = container.read(cashOutProvider);
      final id = state.entries.first.id;

      await notifier.updateEntry(
        id: id,
        amount: 999,
        category: CashOutCategory.miscellaneous,
        description: 'Updated',
      );

      state = container.read(cashOutProvider);
      expect(state.entries.first.amount, equals(999));
      expect(state.entries.first.category, equals('miscellaneous'));
      expect(state.entries.first.description, equals('Updated'));
    });
  });
}
