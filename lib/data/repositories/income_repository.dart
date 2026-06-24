import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';

class IncomeRepository {
  final AppDatabase _db;

  IncomeRepository(this._db);

  Future<int> saveDailyIncome(DailyIncomeRecordsCompanion entry) {
    return _db.into(_db.dailyIncomeRecords).insert(
          entry,
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<DailyIncomeRecord?> getByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return (_db.select(_db.dailyIncomeRecords)
          ..where((t) => t.date.equals(dateOnly)))
        .getSingleOrNull();
  }

  Future<List<DailyIncomeRecord>> getByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return (_db.select(_db.dailyIncomeRecords)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<DailyIncomeRecord>> getAll() {
    return (_db.select(_db.dailyIncomeRecords)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<DailyIncomeRecord?> getHighestIncome() async {
    final records = await getAll();
    if (records.isEmpty) return null;
    return records.reduce(
      (a, b) => _computeGross(a) >= _computeGross(b) ? a : b,
    );
  }

  Future<int> getGrossIncomeForDateRange(DateTime start, DateTime end) async {
    final records = await getByDateRange(start, end);
    var total = 0;
    for (final r in records) {
      total += _computeGross(r);
    }
    return total;
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

  Future<int> getTotalIncome() async {
    final records = await getAll();
    var total = 0;
    for (final r in records) {
      total += _computeGross(r);
    }
    return total;
  }

  Future<bool> deleteRecord(int id) async {
    await (_db.delete(_db.dailyIncomeRecords)..where((t) => t.id.equals(id))).go();
    return true;
  }

  Future<bool> updateRecord(int id, DailyIncomeRecordsCompanion entry) async {
    await (_db.update(_db.dailyIncomeRecords)..where((t) => t.id.equals(id))).write(entry);
    return true;
  }
}
