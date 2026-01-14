import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/transaction_model.dart';

class ExportService {
  /// CSV EXPORT (unchanged – already correct)
  static Future<void> exportCSV(List<TransactionModel> transactions) async {
    final rows = <List<String>>[
      ['Date', 'Title', 'Category', 'Amount', 'Type'],
      ...transactions.map(
        (t) => [
          t.date.toIso8601String(),
          t.title,
          t.category,
          t.amount.toString(),
          t.type.name,
        ],
      ),
    ];

    final csv = const ListToCsvConverter().convert(rows);

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/cointrail_export.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'CoinTrail – Expense Export (CSV)');
  }

  /// PDF EXPORT (FIXED – Unicode safe)
  static Future<void> exportPDF(List<TransactionModel> transactions) async {
    final pdf = pw.Document();

    // ✅ Load Unicode fonts
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
        build: (_) => [
          pw.Text(
            'CoinTrail – Expense Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),

          ...transactions.map(
            (t) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Text(
                '${t.title} • ${t.category} • ₹${t.amount} (${t.type.name})',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/cointrail_export.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'CoinTrail – Expense Export (PDF)');
  }
}
