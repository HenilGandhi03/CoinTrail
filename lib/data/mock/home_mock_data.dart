// import 'package:cointrail/data/models/category_spending_model.dart';
// import 'package:cointrail/data/models/expense_summary_model.dart';
// import 'package:cointrail/data/models/monthly_summary_model.dart';
// import 'package:cointrail/data/models/incomeSummaryModel.dart';
// import 'package:cointrail/data/models/transaction_model.dart';
// import 'package:flutter/material.dart';

// class HomeMockData {
//   // User
//   static const String userName = 'Sarah';

//   static final expenseSummary = ExpenseSummaryModel(
//     totalExpense: 2847,
//     today: 120,
//     categories: 6,
//     budget: 3500,
//     progress: 2847 / 3500,
//   );

//   static final incomeSummary = IncomeSummaryModel(
//     totalIncome: 5200,
//     source: 'Primary Income',
//     nextDate: '28 Sep',
//     growthPercent: 5.4,
//   );

//   // Monthly summary
//   static const MonthlySummaryModel monthlySummary = MonthlySummaryModel(
//     totalSpent: 2847,
//     budget: 3500,
//     daysLeft: 9,
//   );

//   // Transactions
//   static final List<TransactionModel> transactions = [
//     TransactionModel(
//       id: '1',
//       title: 'Salary',
//       amount: 3200,
//       type: TransactionType.income,
//       category: 'Income',
//       date: DateTime(2025, 1, 1),
//     ),
//     TransactionModel(
//       id: '2',
//       title: 'Groceries',
//       amount: 150,
//       type: TransactionType.expense,
//       category: 'Food',
//       date: DateTime(2025, 1, 5),
//     ),
//     TransactionModel(
//       id: '3',
//       title: 'Uber',
//       amount: 80,
//       type: TransactionType.expense,
//       category: 'Transport',
//       date: DateTime(2025, 1, 7),
//     ),
//     TransactionModel(
//       id: '4',
//       title: 'Electricity Bill',
//       amount: 220,
//       type: TransactionType.expense,
//       category: 'Bills',
//       date: DateTime(2025, 1, 10),
//     ),
//     TransactionModel(
//       id: '5',
//       title: 'Amazon',
//       amount: 350,
//       type: TransactionType.expense,
//       category: 'Shopping',
//       date: DateTime(2025, 1, 12),
//     ),
//   ];

//   // Category breakdown
//   static const List<CategorySpendingModel> categories = [
//     CategorySpendingModel(
//       name: 'Food',
//       amount: 1150,
//       percentage: 40,
//       color: Color(0xFFEF4444),
//     ),
//     CategorySpendingModel(
//       name: 'Transport',
//       amount: 680,
//       percentage: 24,
//       color: Color(0xFF3B82F6),
//     ),
//     CategorySpendingModel(
//       name: 'Bills',
//       amount: 520,
//       percentage: 18,
//       color: Color(0xFF22C55E),
//     ),
//     CategorySpendingModel(
//       name: 'Shopping',
//       amount: 350,
//       percentage: 12,
//       color: Color(0xFFF59E0B),
//     ),
//     CategorySpendingModel(
//       name: 'Others',
//       amount: 147,
//       percentage: 6,
//       color: Color(0xFF9CA3AF),
//     ),
//   ];
// }
