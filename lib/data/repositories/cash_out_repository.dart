import 'package:drift/drift.dart' hide Column;

import '../database/app_database.dart';

class CashOutRepository {
  final AppDatabase _db;

  CashOutRepository(this._db);

  Future<int> addCashOut(CashOutEntriesCompanion entry) {
    return _db.into(_db.cashOutEntries).insert(entry);
  }

  Future<bool> updateCashOut(int id, CashOutEntriesCompanion entry) async {
    await (_db.update(_db.cashOutEntries)..where((t) => t.id.equals(id))).write(entry);
    return true;
  }

  Future<bool> deleteCashOut(int id) async {
    await (_db.delete(_db.cashOutEntries)..where((t) => t.id.equals(id))).go();
    return true;
  }

  Future<CashOutEntry?> getById(int id) {
    return (_db.select(_db.cashOutEntries)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<CashOutEntry>> getByDateRange(DateTime start, DateTime end) {
    return (_db.select(_db.cashOutEntries)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<List<CashOutEntry>> getByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return (_db.select(_db.cashOutEntries)..where((t) => t.date.equals(dateOnly)))
        .get();
  }

  Future<List<CashOutEntry>> getAll() {
    return (_db.select(_db.cashOutEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> getTotalCashOutForDateRange(DateTime start, DateTime end) async {
    final entries = await getByDateRange(start, end);
    var total = 0;
    for (final e in entries) {
      total += e.amount;
    }
    return total;
  }

  Future<int> getTotalCashOutForDate(DateTime date) async {
    final entries = await getByDate(date);
    var total = 0;
    for (final e in entries) {
      total += e.amount;
    }
    return total;
  }

  Future<int> getTotalCashOut() async {
    final entries = await getAll();
    var total = 0;
    for (final e in entries) {
      total += e.amount;
    }
    return total;
  }
}
