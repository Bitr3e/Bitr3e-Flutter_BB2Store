import 'package:drift/drift.dart';

class DailyIncomeRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()();
  IntColumn get p1 => integer().withDefault(const Constant(0))();
  IntColumn get p5 => integer().withDefault(const Constant(0))();
  IntColumn get p10 => integer().withDefault(const Constant(0))();
  IntColumn get p20 => integer().withDefault(const Constant(0))();
  IntColumn get p50 => integer().withDefault(const Constant(0))();
  IntColumn get p100 => integer().withDefault(const Constant(0))();
  IntColumn get p200 => integer().withDefault(const Constant(0))();
  IntColumn get p500 => integer().withDefault(const Constant(0))();
  IntColumn get p1000 => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
