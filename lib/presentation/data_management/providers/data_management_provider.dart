import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../data/database/app_database.dart';
import '../../../data/repositories/cash_out_repository.dart';
import '../../../data/repositories/income_repository.dart';
import '../../../domain/providers/repository_providers.dart';
import '../../../services/csv_service.dart';

class DataManagementState {
  final bool isExporting;
  final bool isImporting;
  final String? message;
  final List<String> backupFiles;
  final bool isLoadingBackups;

  const DataManagementState({
    this.isExporting = false,
    this.isImporting = false,
    this.message,
    this.backupFiles = const [],
    this.isLoadingBackups = false,
  });

  DataManagementState copyWith({
    bool? isExporting,
    bool? isImporting,
    String? message,
    List<String>? backupFiles,
    bool? isLoadingBackups,
    bool clearMessage = false,
  }) {
    return DataManagementState(
      isExporting: isExporting ?? this.isExporting,
      isImporting: isImporting ?? this.isImporting,
      message: clearMessage ? null : (message ?? this.message),
      backupFiles: backupFiles ?? this.backupFiles,
      isLoadingBackups: isLoadingBackups ?? this.isLoadingBackups,
    );
  }
}

class DataManagementNotifier extends StateNotifier<DataManagementState> {
  DataManagementNotifier(this._ref) : super(const DataManagementState());

  final Ref _ref;

  IncomeRepository get _incomeRepo => _ref.read(incomeRepositoryProvider);
  CashOutRepository get _cashOutRepo => _ref.read(cashOutRepositoryProvider);
  Future<String> _getBackupDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  Future<void> loadBackups() async {
    state = state.copyWith(isLoadingBackups: true);
    try {
      final backupDir = await _getBackupDir();
      final dir = Directory(backupDir);
      final files = await dir.list().toList();
      final csvFiles = files
          .where((f) => f.path.endsWith('.csv'))
          .map((f) => f.path)
          .toList()
        ..sort((a, b) => b.compareTo(a));
      state = state.copyWith(
        backupFiles: csvFiles,
        isLoadingBackups: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingBackups: false,
        message: 'Failed to load backups: $e',
      );
    }
  }

  Future<void> exportAll() async {
    state = state.copyWith(isExporting: true, clearMessage: true);
    try {
      final backupDir = await _getBackupDir();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;

      final incomeRecords = await _incomeRepo.getAll();
      final cashOutEntries = await _cashOutRepo.getAll();

      if (incomeRecords.isEmpty && cashOutEntries.isEmpty) {
        state = state.copyWith(
          isExporting: false,
          message: 'No data to export',
        );
        return;
      }

      String? incomePath;
      String? cashOutPath;

      if (incomeRecords.isNotEmpty) {
        incomePath = await CsvService.exportIncomeToCsv(
          incomeRecords,
          '$backupDir/income_$timestamp.csv',
          (r) => (r as DailyIncomeRecord).p1,
          (r) => (r as DailyIncomeRecord).p5,
          (r) => (r as DailyIncomeRecord).p10,
          (r) => (r as DailyIncomeRecord).p20,
          (r) => (r as DailyIncomeRecord).p50,
          (r) => (r as DailyIncomeRecord).p100,
          (r) => (r as DailyIncomeRecord).p200,
          (r) => (r as DailyIncomeRecord).p500,
          (r) => (r as DailyIncomeRecord).p1000,
          (r) => (r as DailyIncomeRecord).date,
        );
      }

      if (cashOutEntries.isNotEmpty) {
        cashOutPath = await CsvService.exportCashOutToCsv(
          cashOutEntries,
          '$backupDir/cashout_$timestamp.csv',
          (e) => (e as CashOutEntry).date,
          (e) => (e as CashOutEntry).amount,
          (e) => (e as CashOutEntry).category,
          (e) => (e as CashOutEntry).description,
        );
      }

      final parts = <String>[];
      if (incomePath != null) parts.add('Income');
      if (cashOutPath != null) parts.add('Cash-Out');

      state = state.copyWith(
        isExporting: false,
        message: 'Exported: ${parts.join(', ')}',
      );
      loadBackups();
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        message: 'Export failed: $e',
      );
    }
  }

  Future<void> importFromFile(String filePath) async {
    state = state.copyWith(isImporting: true, clearMessage: true);
    try {
      final fileName = filePath.split('\\').last.split('/').last;

      if (fileName.startsWith('income_')) {
        final rows = await CsvService.importIncomeFromCsv(filePath);
        var count = 0;
        for (final r in rows) {
          final companion = DailyIncomeRecordsCompanion(
            date: Value(r.date),
            p1: Value(r.p1),
            p5: Value(r.p5),
            p10: Value(r.p10),
            p20: Value(r.p20),
            p50: Value(r.p50),
            p100: Value(r.p100),
            p200: Value(r.p200),
            p500: Value(r.p500),
            p1000: Value(r.p1000),
          );
          await _incomeRepo.saveDailyIncome(companion);
          count++;
        }
        state = state.copyWith(
          isImporting: false,
          message: 'Imported $count income records',
        );
      } else if (fileName.startsWith('cashout_')) {
        final rows = await CsvService.importCashOutFromCsv(filePath);
        var count = 0;
        for (final e in rows) {
          final companion = CashOutEntriesCompanion(
            date: Value(e.date),
            amount: Value(e.amount),
            category: Value(e.category),
            description: Value(e.description),
          );
          await _cashOutRepo.addCashOut(companion);
          count++;
        }
        state = state.copyWith(
          isImporting: false,
          message: 'Imported $count cash-out records',
        );
      } else {
        state = state.copyWith(
          isImporting: false,
          message: 'Unknown file format: $fileName',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        message: 'Import failed: $e',
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }
}

final dataManagementProvider = StateNotifierProvider<DataManagementNotifier, DataManagementState>(
  (ref) => DataManagementNotifier(ref),
);
