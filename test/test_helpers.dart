import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'package:bb2store_cash_inventory/data/database/app_database.dart';
import 'package:bb2store_cash_inventory/data/database/tables/daily_income_table.dart';
import 'package:bb2store_cash_inventory/data/database/tables/cash_out_table.dart';

AppDatabase createInMemoryDb() {
  return AppDatabase(NativeDatabase.memory());
}

Future<void> seedIncome(
  AppDatabase db, {
  DateTime? date,
  int p1 = 0, int p5 = 0, int p10 = 0, int p20 = 0, int p50 = 0,
  int p100 = 0, int p200 = 0, int p500 = 0, int p1000 = 0,
}) async {
  final d = date ?? DateTime.now();
  await db.into(db.dailyIncomeRecords).insert(
    DailyIncomeRecordsCompanion(
      date: Value(DateTime(d.year, d.month, d.day)),
      p1: Value(p1), p5: Value(p5), p10: Value(p10),
      p20: Value(p20), p50: Value(p50), p100: Value(p100),
      p200: Value(p200), p500: Value(p500), p1000: Value(p1000),
    ),
  );
}

Future<void> seedCashOut(
  AppDatabase db, {
  DateTime? date,
  int amount = 0,
  String category = 'storeExpenses',
  String? description,
}) async {
  final d = date ?? DateTime.now();
  await db.into(db.cashOutEntries).insert(
    CashOutEntriesCompanion(
      date: Value(DateTime(d.year, d.month, d.day)),
      amount: Value(amount),
      category: Value(category),
      description: Value(description),
    ),
  );
}

DailyIncomeRecord incomeRecord({
  DateTime? date,
  int p1 = 0, int p5 = 0, int p10 = 0, int p20 = 0, int p50 = 0,
  int p100 = 0, int p200 = 0, int p500 = 0, int p1000 = 0,
  int? id,
  DateTime? createdAt,
}) {
  return DailyIncomeRecord(
    id: id ?? 1,
    date: date ?? DateTime.now(),
    p1: p1, p5: p5, p10: p10, p20: p20, p50: p50,
    p100: p100, p200: p200, p500: p500, p1000: p1000,
    createdAt: createdAt ?? DateTime.now(),
  );
}

CashOutEntry cashOutEntry({
  DateTime? date,
  int amount = 0,
  String category = 'storeExpenses',
  String? description,
  int? id,
  DateTime? createdAt,
}) {
  return CashOutEntry(
    id: id ?? 1,
    date: date ?? DateTime.now(),
    amount: amount,
    category: category,
    description: description,
    createdAt: createdAt ?? DateTime.now(),
  );
}
