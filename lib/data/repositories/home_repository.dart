// import '../mock/home_mock_data.dart';
// import 'package:cointrail/data/models/category_spending_model.dart';
// import 'package:cointrail/data/models/monthly_summary_model.dart';
// import 'package:cointrail/data/models/transaction_model.dart';
// import 'package:cointrail/data/models/expense_summary_model.dart';
// import 'package:cointrail/data/models/incomeSummaryModel.dart';

// class HomeRepository {
//   String getUserName() => HomeMockData.userName;

//   MonthlySummaryModel getMonthlySummary() => HomeMockData.monthlySummary;

//   ExpenseSummaryModel getExpenseSummary() => HomeMockData.expenseSummary;

//   IncomeSummaryModel getIncomeSummary() => HomeMockData.incomeSummary;

//   List<CategorySpendingModel> getCategories() => HomeMockData.categories;

//   List<TransactionModel> getRecentTransactions({int limit = 5}) {
//     return HomeMockData.transactions.take(limit).toList();
//   }

//   void addTransaction(TransactionModel transaction) {
//     HomeMockData.transactions.insert(0, transaction);
//   }

//   List<TransactionModel> getAllTransactions() {
//     return List.unmodifiable(HomeMockData.transactions);
//   }
// }

import 'dart:ui';

import 'package:cointrail/data/models/category_spending_model.dart';
import 'package:cointrail/data/models/expense_summary_model.dart';
import 'package:cointrail/data/models/incomeSummaryModel.dart';
import 'package:cointrail/data/models/monthly_summary_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';

class HomeRepository {
  final _txRepo = TransactionRepository();

  // ───────── User (temporary) ─────────
  String getUserName() => 'Sarah';

  // ───────── Transactions ─────────
  List<TransactionModel> getRecentTransactions({int limit = 5}) {
    return _txRepo.getRecent(limit: limit);
  }

  List<TransactionModel> getAllTransactions() {
    return _txRepo.getAllSorted();
  }

  // ───────── Monthly Summary ─────────
  MonthlySummaryModel getMonthlySummary() {
    final txs = _txRepo.getAllSorted();
    final spent = txs
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    const budget = 3500.0;

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
  ExpenseSummaryModel getExpenseSummary() {
    final txs = _txRepo.getAllSorted();

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

    return ExpenseSummaryModel(
      totalExpense: total,
      today: today,
      categories: expenses.map((e) => e.category).toSet().length,
      budget: 3500,
      progress: total / 3500,
    );
  }

  // ───────── Income Summary ─────────
  IncomeSummaryModel getIncomeSummary() {
    final txs = _txRepo.getAllSorted();

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
      (t) => t.type == TransactionType.expense,
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
            : ((e.value / grandTotal) * 100).round(),
        color: const Color(0xFF9CA3AF),
      );
    }).toList();
  }
}
