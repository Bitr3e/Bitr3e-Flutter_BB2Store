import 'package:drift/drift.dart';

class CashOutEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
