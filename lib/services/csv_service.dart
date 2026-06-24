import 'dart:io';

class ImportedIncomeRow {
  final DateTime date;
  final int p1, p5, p10, p20, p50, p100, p200, p500, p1000;

  ImportedIncomeRow({
    required this.date,
    this.p1 = 0, this.p5 = 0, this.p10 = 0,
    this.p20 = 0, this.p50 = 0, this.p100 = 0,
    this.p200 = 0, this.p500 = 0, this.p1000 = 0,
  });
}

class ImportedCashOutRow {
  final DateTime date;
  final int amount;
  final String category;
  final String? description;

  ImportedCashOutRow({
    required this.date,
    required this.amount,
    required this.category,
    this.description,
  });
}

class CsvService {
  static const _incomeHeader =
      'Date,P1,P5,P10,P20,P50,P100,P200,P500,P1000,Gross Income';
  static const _cashOutHeader = 'Date,Amount,Category,Description';

  static Future<String> exportIncomeToCsv(
    List<dynamic> records,
    String filePath,
    int Function(dynamic r) getP1,
    int Function(dynamic r) getP5,
    int Function(dynamic r) getP10,
    int Function(dynamic r) getP20,
    int Function(dynamic r) getP50,
    int Function(dynamic r) getP100,
    int Function(dynamic r) getP200,
    int Function(dynamic r) getP500,
    int Function(dynamic r) getP1000,
    DateTime Function(dynamic r) getDate,
  ) async {
    final lines = <String>[_incomeHeader];

    for (final r in records) {
      final d = getDate(r);
      final dateStr =
          '${d.year}-${_pad(d.month)}-${_pad(d.day)}';
      final p1 = getP1(r);
      final p5 = getP5(r);
      final p10 = getP10(r);
      final p20 = getP20(r);
      final p50 = getP50(r);
      final p100 = getP100(r);
      final p200 = getP200(r);
      final p500 = getP500(r);
      final p1000 = getP1000(r);
      final gross = p1 * 1 + p5 * 5 + p10 * 10 + p20 * 20 +
          p50 * 50 + p100 * 100 + p200 * 200 +
          p500 * 500 + p1000 * 1000;
      lines.add(
        '$dateStr,$p1,$p5,$p10,$p20,$p50,$p100,$p200,$p500,$p1000,$gross',
      );
    }

    final file = File(filePath);
    await file.writeAsString(lines.join('\n'));
    return filePath;
  }

  static Future<String> exportCashOutToCsv(
    List<dynamic> entries,
    String filePath,
    DateTime Function(dynamic e) getDate,
    int Function(dynamic e) getAmount,
    String Function(dynamic e) getCategory,
    String? Function(dynamic e) getDescription,
  ) async {
    final lines = <String>[_cashOutHeader];

    for (final e in entries) {
      final d = getDate(e);
      final dateStr =
          '${d.year}-${_pad(d.month)}-${_pad(d.day)}';
      final desc = (getDescription(e) ?? '').replaceAll(',', ' ');
      lines.add('$dateStr,${getAmount(e)},${getCategory(e)},$desc');
    }

    final file = File(filePath);
    await file.writeAsString(lines.join('\n'));
    return filePath;
  }

  static Future<List<ImportedIncomeRow>> importIncomeFromCsv(
    String filePath,
  ) async {
    final file = File(filePath);
    final content = await file.readAsString();
    final lines = content.split('\n');

    if (lines.length < 2) return [];

    final records = <ImportedIncomeRow>[];
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(',');
      if (parts.length < 11) continue;

      final dateParts = parts[0].split('-');
      if (dateParts.length != 3) continue;

      records.add(ImportedIncomeRow(
        date: DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        ),
        p1: int.tryParse(parts[1]) ?? 0,
        p5: int.tryParse(parts[2]) ?? 0,
        p10: int.tryParse(parts[3]) ?? 0,
        p20: int.tryParse(parts[4]) ?? 0,
        p50: int.tryParse(parts[5]) ?? 0,
        p100: int.tryParse(parts[6]) ?? 0,
        p200: int.tryParse(parts[7]) ?? 0,
        p500: int.tryParse(parts[8]) ?? 0,
        p1000: int.tryParse(parts[9]) ?? 0,
      ));
    }

    return records;
  }

  static Future<List<ImportedCashOutRow>> importCashOutFromCsv(
    String filePath,
  ) async {
    final file = File(filePath);
    final content = await file.readAsString();
    final lines = content.split('\n');

    if (lines.length < 2) return [];

    final entries = <ImportedCashOutRow>[];
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(',');
      if (parts.length < 4) continue;

      final dateParts = parts[0].split('-');
      if (dateParts.length != 3) continue;

      entries.add(ImportedCashOutRow(
        date: DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        ),
        amount: int.tryParse(parts[1]) ?? 0,
        category: parts[2],
        description: parts[3].isNotEmpty ? parts[3] : null,
      ));
    }

    return entries;
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
