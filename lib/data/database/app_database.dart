import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/cash_out_table.dart';
import 'tables/daily_income_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DailyIncomeRecords,
    CashOutEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  static Future<AppDatabase> create() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bb2store.db'));
    final nativeDb = NativeDatabase(file);
    return AppDatabase(nativeDb);
  }
}
