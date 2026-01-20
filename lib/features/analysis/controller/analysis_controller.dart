import 'dart:async';
import 'package:cointrail/data/models/category_spending_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:cointrail/data/sources/local/settings_hive_source.dart';
import 'package:cointrail/features/analysis/screen/analysis_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum AnalysisChartType { expense, income }

class AnalysisController extends ChangeNotifier {
  final TransactionRepository _transactionRepo = TransactionRepository();
  final SettingsHiveSource _settingsRepo = SettingsHiveSource();

  late StreamSubscription _hiveSubscription;
  late StreamSubscription _settingsSubscription;

  AnalysisRangeType rangeType = AnalysisRangeType.weekly;
  DateTimeRange range = _currentWeek();

  double _totalIncome = 0;
  double _totalExpense = 0;
  double _monthlyLimit = 20000;
  List<CategorySpendingModel> _categories = [];
  Map<String, List<CategorySpendingModel>> _categoriesByType = {
    'income': [],
    'expense': [],
  };

  // Getters
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  double get monthlyLimit => _monthlyLimit;

  DateTime get rangeStart => range.start;
  DateTime get rangeEnd => range.end;

  List<CategorySpendingModel> get categories => _categories;
  List<CategorySpendingModel> get expenseCategories =>
      _categoriesByType['expense'] ?? [];
  List<CategorySpendingModel> get incomeCategories =>
      _categoriesByType['income'] ?? [];

  AnalysisController() {
    _init();
  }

  Future<void> _init() async {
    await _loadData();
    _listenToHive();
    _listenToSettingsBox();
  }

  Future<void> _loadData() async {
    // Load settings
    _monthlyLimit = await _settingsRepo.getBudget();

    // Get transactions in current range
    final transactions = _getTransactionsInRange();

    // Calculate totals
    _totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Generate category breakdowns
    _generateCategoryBreakdowns(transactions);

    notifyListeners();
  }

  void _listenToHive() {
    _hiveSubscription = Hive.box<TransactionModel>(
      'transactions',
    ).watch().listen((_) => _loadData());
  }

  void _listenToSettingsBox() {
    _settingsSubscription = Hive.box('settingsBox').watch().listen((event) {
      if (event.key == 'monthlyBudget') {
        // Reload data when monthly budget changes
        _loadData();
      }
    });
  }

  List<TransactionModel> _getTransactionsInRange() {
    final allTransactions = _transactionRepo.getAllSorted();
    return allTransactions.where((transaction) {
      return transaction.date.isAfter(
            range.start.subtract(const Duration(days: 1)),
          ) &&
          transaction.date.isBefore(range.end.add(const Duration(days: 1)));
    }).toList();
  }

  void _generateCategoryBreakdowns(List<TransactionModel> transactions) {
    // Separate income and expense transactions
    final incomeTransactions = transactions
        .where((t) => t.type == TransactionType.income)
        .toList();
    final expenseTransactions = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    // Generate category spending for income
    _categoriesByType['income'] = _generateCategorySpendingList(
      incomeTransactions,
    );

    // Generate category spending for expenses
    _categoriesByType['expense'] = _generateCategorySpendingList(
      expenseTransactions,
    );

    // Default to expense categories
    _categories = _categoriesByType['expense'] ?? [];
  }

  List<CategorySpendingModel> _generateCategorySpendingList(
    List<TransactionModel> transactions,
  ) {
    if (transactions.isEmpty) return [];

    final Map<String, double> categoryTotals = {};

    // Calculate totals for each category
    for (final transaction in transactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    final grandTotal = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );

    // Convert to CategorySpendingModel list
    final categories = categoryTotals.entries.map((entry) {
      final percentage = grandTotal == 0
          ? 0
          : ((entry.value / grandTotal) * 100).round();

      return CategorySpendingModel(
        name: entry.key,
        amount: entry.value,
        percentage: percentage,
        color: _getCategoryColor(entry.key),
      );
    }).toList();

    // Sort by amount (descending)
    categories.sort((a, b) => b.amount.compareTo(a.amount));

    return categories;
  }

  Color _getCategoryColor(String categoryName) {
    // Simple color mapping based on category name
    final colorMap = {
      'Food': const Color(0xFFEF4444),
      'Transport': const Color(0xFF3B82F6),
      'Bills': const Color(0xFF22C55E),
      'Shopping': const Color(0xFFF59E0B),
      'Entertainment': const Color(0xFF8B5CF6),
      'Health': const Color(0xFFEC4899),
      'Salary': const Color(0xFF10B981),
      'Freelance': const Color(0xFF6366F1),
      'Investment': const Color(0xFF059669),
      'Others': const Color(0xFF9CA3AF),
    };

    return colorMap[categoryName] ?? const Color(0xFF9CA3AF);
  }

  void updateCategoriesForType(bool isIncome) {
    _categories = isIncome
        ? (_categoriesByType['income'] ?? [])
        : (_categoriesByType['expense'] ?? []);
    notifyListeners();
  }

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
    _loadData();
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
    _loadData();
  }

  void switchRange(AnalysisRangeType type) {
    rangeType = type;

    if (type == AnalysisRangeType.weekly) {
      range = _currentWeek();
    } else if (type == AnalysisRangeType.monthly) {
      range = _currentMonth();
    }

    _loadData();
  }

  void setCustomRange(DateTimeRange newRange) {
    rangeType = AnalysisRangeType.custom;
    range = newRange;
    _loadData();
  }

  @override
  void dispose() {
    _hiveSubscription.cancel();
    _settingsSubscription.cancel();
    super.dispose();
  }
}
