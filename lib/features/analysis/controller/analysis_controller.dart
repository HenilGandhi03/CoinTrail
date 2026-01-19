import 'package:cointrail/data/models/category_spending_model.dart';
import 'package:cointrail/features/analysis/screen/analysis_page.dart';
import 'package:flutter/material.dart';

enum AnalysisChartType { expense, income }

class AnalysisController extends ChangeNotifier {
  AnalysisRangeType rangeType = AnalysisRangeType.weekly;

  DateTimeRange range = _currentWeek();

  double totalIncome = 5200;
  double totalExpense = 3400;
  double monthlyLimit = 20000;

  double get balance => totalIncome - totalExpense;

  DateTime get rangeStart => range.start;
  DateTime get rangeEnd => range.end;
  final Map<String, double> categoryBreakdown = {
    'Food': 1200,
    'Transport': 600,
    'Shopping': 900,
    'Bills': 700,
  };
  // ───────── RANGE HELPERS ─────────
  static DateTimeRange _currentWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(start: start, end: start.add(const Duration(days: 6)));
  }

  static DateTimeRange _currentMonth() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  // ───────── NAVIGATION ─────────
  void previous() {
    if (rangeType == AnalysisRangeType.weekly) {
      range = DateTimeRange(
        start: range.start.subtract(const Duration(days: 7)),
        end: range.end.subtract(const Duration(days: 7)),
      );
    } else if (rangeType == AnalysisRangeType.monthly) {
      range = DateTimeRange(
        start: DateTime(range.start.year, range.start.month - 1, 1),
        end: DateTime(range.start.year, range.start.month, 0),
      );
    }
    notifyListeners();
  }

  void next() {
    if (rangeType == AnalysisRangeType.weekly) {
      range = DateTimeRange(
        start: range.start.add(const Duration(days: 7)),
        end: range.end.add(const Duration(days: 7)),
      );
    } else if (rangeType == AnalysisRangeType.monthly) {
      range = DateTimeRange(
        start: DateTime(range.start.year, range.start.month + 1, 1),
        end: DateTime(range.start.year, range.start.month + 2, 0),
      );
    }
    notifyListeners();
  }

  void switchRange(AnalysisRangeType type) {
    rangeType = type;

    if (type == AnalysisRangeType.weekly) {
      range = _currentWeek();
    } else if (type == AnalysisRangeType.monthly) {
      range = _currentMonth();
    }

    notifyListeners();
  }

  void setCustomRange(DateTimeRange newRange) {
    rangeType = AnalysisRangeType.custom;
    range = newRange;
    notifyListeners();
  }

  // lib/features/home/controller/home_controller.dart
}
