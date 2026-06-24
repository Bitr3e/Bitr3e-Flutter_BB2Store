import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNotNull, isNull;

import 'package:bb2store_cash_inventory/data/database/app_database.dart';
import 'package:bb2store_cash_inventory/data/repositories/income_repository.dart';
import 'package:bb2store_cash_inventory/domain/providers/database_provider.dart';
import 'package:bb2store_cash_inventory/domain/providers/repository_providers.dart';
import 'package:bb2store_cash_inventory/presentation/income_recording/providers/income_recording_provider.dart';

import '../test_helpers.dart';

void main() {
  group('IncomeRecordingNotifier', () {
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
        ],
      );
    });

    tearDown(() {
      container.dispose();
      db.close();
    });

    test('initial state has zero quantities for all denominations', () {
      final state = container.read(incomeRecordingProvider);
      expect(state.quantities.length, equals(9));
      expect(state.quantities.values.every((v) => v == 0), isTrue);
      expect(state.isSaving, isFalse);
    });

    test('updateQuantity changes the quantity for a denomination', () {
      container.read(incomeRecordingProvider.notifier).updateQuantity(100, 5);
      final state = container.read(incomeRecordingProvider);
      expect(state.quantities[100], equals(5));
      expect(state.quantities[1], equals(0));
    });

    test('updateQuantity ignores negative values', () {
      container.read(incomeRecordingProvider.notifier).updateQuantity(50, -1);
      final state = container.read(incomeRecordingProvider);
      expect(state.quantities[50], equals(0));
    });

    test('grossIncome calculates correct total', () {
      final notifier = container.read(incomeRecordingProvider.notifier);
      notifier.updateQuantity(1000, 2);
      notifier.updateQuantity(100, 3);
      final state = container.read(incomeRecordingProvider);
      expect(state.grossIncome, equals(2300));
    });

    test('grossIncome returns 0 with no quantities', () {
      final state = container.read(incomeRecordingProvider);
      expect(state.grossIncome, equals(0));
    });

    test('save persists and returns true', () async {
      final notifier = container.read(incomeRecordingProvider.notifier);
      notifier.updateQuantity(1000, 1);
      final success = await notifier.save();
      expect(success, isTrue);

      final repo = IncomeRepository(db);
      final today = DateTime.now();
      final record = await repo.getByDate(today);
      expect(record, isNot(isNull));
      expect(record!.p1000, equals(1));
    });

    test('save creates new record each day (replaces existing)', () async {
      final notifier = container.read(incomeRecordingProvider.notifier);
      notifier.updateQuantity(500, 2);
      await notifier.save();

      notifier.updateQuantity(500, 5);
      await notifier.save();

      final repo = IncomeRepository(db);
      final records = await repo.getAll();
      expect(records.length, equals(1));
      expect(records.first.p500, equals(5));
    });
  });
}
