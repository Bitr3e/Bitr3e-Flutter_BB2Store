import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:bb2store_cash_inventory/services/csv_service.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('csv_test_');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('CsvService', () {
    group('exportIncomeToCsv', () {
      test('writes header and rows', () async {
        final records = [
          _TestIncomeRecord(
            date: DateTime(2026, 6, 24),
            p1: 1, p5: 2, p10: 3, p20: 4, p50: 5,
            p100: 6, p200: 7, p500: 8, p1000: 9,
          ),
        ];
        final path = '${tempDir.path}/income_test.csv';

        final result = await CsvService.exportIncomeToCsv(
          records, path,
          (r) => (r as _TestIncomeRecord).p1,
          (r) => (r as _TestIncomeRecord).p5,
          (r) => (r as _TestIncomeRecord).p10,
          (r) => (r as _TestIncomeRecord).p20,
          (r) => (r as _TestIncomeRecord).p50,
          (r) => (r as _TestIncomeRecord).p100,
          (r) => (r as _TestIncomeRecord).p200,
          (r) => (r as _TestIncomeRecord).p500,
          (r) => (r as _TestIncomeRecord).p1000,
          (r) => (r as _TestIncomeRecord).date,
        );

        expect(result, equals(path));
        final content = await File(path).readAsString();
        expect(content, contains('Date,P1,P5,P10,P20,P50,P100,P200,P500,P1000,Gross Income'));
        expect(content, contains('2026-06-24,1,2,3,4,5,6,7,8,9,15371'));
      });

      test('empty records writes only header', () async {
        final path = '${tempDir.path}/income_empty.csv';
        await CsvService.exportIncomeToCsv(
          [], path,
          (_) => 0, (_) => 0, (_) => 0, (_) => 0, (_) => 0,
          (_) => 0, (_) => 0, (_) => 0, (_) => 0,
          (_) => DateTime.now(),
        );
        final content = await File(path).readAsString();
        expect(content.split('\n').length, equals(1));
      });

      test('handles multiple records', () async {
        final records = [
          _TestIncomeRecord(date: DateTime(2026, 6, 24), p1000: 5),
          _TestIncomeRecord(date: DateTime(2026, 6, 25), p500: 3),
        ];
        final path = '${tempDir.path}/income_multi.csv';
        await CsvService.exportIncomeToCsv(
          records, path,
          (r) => (r as _TestIncomeRecord).p1,
          (r) => (r as _TestIncomeRecord).p5,
          (r) => (r as _TestIncomeRecord).p10,
          (r) => (r as _TestIncomeRecord).p20,
          (r) => (r as _TestIncomeRecord).p50,
          (r) => (r as _TestIncomeRecord).p100,
          (r) => (r as _TestIncomeRecord).p200,
          (r) => (r as _TestIncomeRecord).p500,
          (r) => (r as _TestIncomeRecord).p1000,
          (r) => (r as _TestIncomeRecord).date,
        );
        final content = await File(path).readAsString();
        expect(content.split('\n').length, equals(3)); // header + 2 data rows
        expect(content, contains('2026-06-25'));
      });
    });

    group('exportCashOutToCsv', () {
      test('writes header and rows', () async {
        final entries = [
          _TestCashOutEntry(
            date: DateTime(2026, 6, 24),
            amount: 500,
            category: 'Store Expenses',
            description: 'Supplies',
          ),
        ];
        final path = '${tempDir.path}/cashout_test.csv';

        final result = await CsvService.exportCashOutToCsv(
          entries, path,
          (e) => (e as _TestCashOutEntry).date,
          (e) => (e as _TestCashOutEntry).amount,
          (e) => (e as _TestCashOutEntry).category,
          (e) => (e as _TestCashOutEntry).description,
        );

        expect(result, equals(path));
        final content = await File(path).readAsString();
        expect(content, contains('Date,Amount,Category,Description'));
        expect(content, contains('2026-06-24,500,Store Expenses,Supplies'));
      });

      test('handles empty description', () async {
        final entries = [
          _TestCashOutEntry(
            date: DateTime(2026, 6, 24),
            amount: 300,
            category: 'Miscellaneous',
            description: null,
          ),
        ];
        final path = '${tempDir.path}/cashout_nodesc.csv';
        await CsvService.exportCashOutToCsv(
          entries, path,
          (e) => (e as _TestCashOutEntry).date,
          (e) => (e as _TestCashOutEntry).amount,
          (e) => (e as _TestCashOutEntry).category,
          (e) => (e as _TestCashOutEntry).description,
        );
        final content = await File(path).readAsString();
        expect(content, contains('2026-06-24,300,Miscellaneous,'));
      });
    });

    group('importIncomeFromCsv', () {
      test('parses valid CSV', () async {
        final path = '${tempDir.path}/import_income.csv';
        await File(path).writeAsString(
          'Date,P1,P5,P10,P20,P50,P100,P200,P500,P1000,Gross Income\n'
          '2026-06-24,1,2,3,4,5,6,7,8,9,15371\n',
        );

        final records = await CsvService.importIncomeFromCsv(path);
        expect(records.length, equals(1));
        expect(records[0].date, equals(DateTime(2026, 6, 24)));
        expect(records[0].p1, equals(1));
        expect(records[0].p1000, equals(9));
      });

      test('returns empty list for file with only header', () async {
        final path = '${tempDir.path}/import_empty.csv';
        await File(path).writeAsString(
          'Date,P1,P5,P10,P20,P50,P100,P200,P500,P1000,Gross Income\n',
        );
        final records = await CsvService.importIncomeFromCsv(path);
        expect(records, isEmpty);
      });

      test('skips malformed rows', () async {
        final path = '${tempDir.path}/import_malformed.csv';
        await File(path).writeAsString(
          'Date,P1,P5,P10,P20,P50,P100,P200,P500,P1000,Gross Income\n'
          '2026-06-24,1,2,3\n',  // too few columns
        );
        final records = await CsvService.importIncomeFromCsv(path);
        expect(records, isEmpty);
      });

      test('handles empty file', () async {
        final path = '${tempDir.path}/import_empty_file.csv';
        await File(path).writeAsString('');
        final records = await CsvService.importIncomeFromCsv(path);
        expect(records, isEmpty);
      });
    });

    group('importCashOutFromCsv', () {
      test('parses valid CSV', () async {
        final path = '${tempDir.path}/import_cashout.csv';
        await File(path).writeAsString(
          'Date,Amount,Category,Description\n'
          '2026-06-24,500,Store Expenses,Office supplies\n',
        );

        final entries = await CsvService.importCashOutFromCsv(path);
        expect(entries.length, equals(1));
        expect(entries[0].date, equals(DateTime(2026, 6, 24)));
        expect(entries[0].amount, equals(500));
        expect(entries[0].category, equals('Store Expenses'));
        expect(entries[0].description, equals('Office supplies'));
      });

      test('handles missing description', () async {
        final path = '${tempDir.path}/import_cashout_nodesc.csv';
        await File(path).writeAsString(
          'Date,Amount,Category,Description\n'
          '2026-06-24,300,Miscellaneous,\n',
        );
        final entries = await CsvService.importCashOutFromCsv(path);
        expect(entries[0].description, isNull);
      });

      test('returns empty list for header-only file', () async {
        final path = '${tempDir.path}/import_cashout_empty.csv';
        await File(path).writeAsString(
          'Date,Amount,Category,Description\n',
        );
        final entries = await CsvService.importCashOutFromCsv(path);
        expect(entries, isEmpty);
      });
    });
  });
}

class _TestIncomeRecord {
  final DateTime date;
  final int p1, p5, p10, p20, p50, p100, p200, p500, p1000;
  _TestIncomeRecord({
    required this.date,
    this.p1 = 0, this.p5 = 0, this.p10 = 0,
    this.p20 = 0, this.p50 = 0, this.p100 = 0,
    this.p200 = 0, this.p500 = 0, this.p1000 = 0,
  });
}

class _TestCashOutEntry {
  final DateTime date;
  final int amount;
  final String category;
  final String? description;
  _TestCashOutEntry({
    required this.date,
    required this.amount,
    required this.category,
    this.description,
  });
}
