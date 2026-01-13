import 'dart:ui';

import 'package:cointrail/common/widgets/logs.dart';
import 'package:cointrail/data/models/category_spending_model.dart';
import 'package:cointrail/data/models/expense_summary_model.dart';
import 'package:cointrail/data/models/incomeSummaryModel.dart';
import 'package:cointrail/data/models/monthly_summary_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:cointrail/data/repositories/user_repository.dart';
import 'package:cointrail/data/sources/local/settings_hive_source.dart';
import 'package:flutter/material.dart';

class HomeRepository {
  final _txRepo = TransactionRepository();
  final _userRepo = UserRepository();
  final _settingsRepo = SettingsHiveSource();

  // ───────── USER ─────────
  // Future<String> getUserName() async {
  //   final user = await _userRepo.getCurrentUser();
  //   debugPrint(
  //     '🟢 Cached user → id: ${user?.id}, '
  //     'email: ${user?.email}, '
  //     'username: ${user?.username}',
  //   );

  //   if (user?.username.isNotEmpty == true) {
  //     debugPrint("📱 Home: Loaded from Firebase: ${user!.username}");
  //     return user.username;
  //   } else {
  //     // Fall back to locally saved name
  //     final savedName = await _settingsRepo.getUserName();
  //     final result = savedName?.isNotEmpty == true ? savedName! : 'Guest';
  //     debugPrint("💾 Home: Loaded from Hive: $result (savedName: $savedName)");
  //     return result;
  //   }
  // }
  Future<String> getUserName() async {
    final user = await _userRepo.getCurrentUser();
    logGreen(
      '🟢 Cached user → id: ${user?.id}, email: ${user?.email}, username: ${user?.username}',
    );
    return user?.username.isNotEmpty == true ? user!.username : 'Guest';
  }

  // ───────── Transactions ─────────
  List<TransactionModel> getRecentTransactions({int limit = 5}) {
    return _txRepo.getRecent(limit: limit);
  }

  List<TransactionModel> getAllTransactions() {
    return _txRepo.getAllSorted();
  }

  // ───────── Monthly Summary ─────────
  bool _isInCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  Future<MonthlySummaryModel> getMonthlySummary() async {
    final txs = _txRepo
        .getAllSorted()
        .where((t) => _isInCurrentMonth(t.date))
        .toList();
    final budget = await _settingsRepo.getBudget();

    final spent = txs
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    return MonthlySummaryModel(
      totalSpent: spent,
      budget: budget,
      daysLeft: DateTime.now()
          .difference(DateTime(DateTime.now().year, DateTime.now().month + 1))
          .inDays
          .abs(),
    );
  }

  // ───────── Expense Summary ─────────
  Future<ExpenseSummaryModel> getExpenseSummary() async {
    final txs = _txRepo
        .getAllSorted()
        .where((t) => _isInCurrentMonth(t.date))
        .toList();
    final budget = await _settingsRepo.getBudget();

    final expenses = txs
        .where((t) => t.type == TransactionType.expense)
        .toList();

    final total = expenses.fold<double>(0, (s, t) => s + t.amount);

    final today = expenses
        .where(
          (t) =>
              t.date.year == DateTime.now().year &&
              t.date.month == DateTime.now().month &&
              t.date.day == DateTime.now().day,
        )
        .fold<double>(0, (s, t) => s + t.amount);

    final progress = budget == 0 ? 0.0 : (total / budget);

    return ExpenseSummaryModel(
      totalExpense: total,
      today: today,
      categories: expenses.map((e) => e.category).toSet().length,
      budget: budget,
      progress: progress,
    );
  }

  // ───────── Income Summary ─────────
  IncomeSummaryModel getIncomeSummary() {
    final txs = _txRepo
        .getAllSorted()
        .where((t) => _isInCurrentMonth(t.date))
        .toList();
    final income = txs
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (s, t) => s + t.amount);

    return IncomeSummaryModel(
      totalIncome: income,
      source: 'Primary Income',
      nextDate: '—',
      growthPercent: 0,
    );
  }

  // ───────── Categories (derived) ─────────
  List<CategorySpendingModel> getCategories() {
    final txs = _txRepo.getAllSorted().where(
      (t) => t.type == TransactionType.expense && _isInCurrentMonth(t.date),
    );

    final Map<String, double> totals = {};

    for (final tx in txs) {
      totals[tx.category] = (totals[tx.category] ?? 0) + tx.amount;
    }

    final grandTotal = totals.values.fold<double>(0, (s, v) => s + v);

    return totals.entries.map((e) {
      return CategorySpendingModel(
        name: e.key,
        amount: e.value,
        percentage: grandTotal == 0
            ? 0
            : ((e.value / grandTotal) * 100).toInt(),
        color: const Color(0xFF9CA3AF),
      );
    }).toList();
  }
}
