// import 'package:cointrail/data/models/transaction_model.dart';
// import 'package:cointrail/data/repositories/transaction_repository.dart';

// class DataSeeder {
//   static final TransactionRepository _txRepo = TransactionRepository();

//   static Future<void> seedSampleData() async {
//     // Check if there are already transactions
//     final existingTransactions = _txRepo.getAllSorted();
//     if (existingTransactions.isNotEmpty) {
//       return; // Don't seed if data already exists
//     }

//     final now = DateTime.now();
//     final sampleTransactions = [
//       // Income transactions
//       TransactionModel(
//         id: 'seed_income_1',
//         title: 'Salary',
//         type: TransactionType.income,
//         amount: 5000,
//         category: 'Salary',
//         date: DateTime(now.year, now.month, 1),
//         paymentMode: PaymentMode.bank,
//       ),
//       TransactionModel(
//         id: 'seed_income_2',
//         title: 'Freelance Project',
//         type: TransactionType.income,
//         amount: 1500,
//         category: 'Freelance',
//         date: DateTime(now.year, now.month, 5),
//         paymentMode: PaymentMode.bank,
//       ),
//       TransactionModel(
//         id: 'seed_income_3',
//         title: 'Investment Returns',
//         type: TransactionType.income,
//         amount: 800,
//         category: 'Investment',
//         date: DateTime(now.year, now.month, 10),
//         paymentMode: PaymentMode.bank,
//       ),

//       // Expense transactions
//       TransactionModel(
//         id: 'seed_expense_1',
//         title: 'Grocery Shopping',
//         type: TransactionType.expense,
//         amount: 450,
//         category: 'Food',
//         date: DateTime(now.year, now.month, 2),
//         paymentMode: PaymentMode.card,
//       ),
//       TransactionModel(
//         id: 'seed_expense_2',
//         title: 'Uber Ride',
//         type: TransactionType.expense,
//         amount: 120,
//         category: 'Transport',
//         date: DateTime(now.year, now.month, 3),
//         paymentMode: PaymentMode.upi,
//       ),
//       TransactionModel(
//         id: 'seed_expense_3',
//         title: 'Electricity Bill',
//         type: TransactionType.expense,
//         amount: 300,
//         category: 'Bills',
//         date: DateTime(now.year, now.month, 4),
//         paymentMode: PaymentMode.bank,
//       ),
//       TransactionModel(
//         id: 'seed_expense_4',
//         title: 'Amazon Purchase',
//         type: TransactionType.expense,
//         amount: 200,
//         category: 'Shopping',
//         date: DateTime(now.year, now.month, 6),
//         paymentMode: PaymentMode.card,
//       ),
//       TransactionModel(
//         id: 'seed_expense_5',
//         title: 'Restaurant Dinner',
//         type: TransactionType.expense,
//         amount: 180,
//         category: 'Food',
//         date: DateTime(now.year, now.month, 8),
//         paymentMode: PaymentMode.cash,
//       ),
//       TransactionModel(
//         id: 'seed_expense_6',
//         title: 'Gas Station',
//         type: TransactionType.expense,
//         amount: 150,
//         category: 'Transport',
//         date: DateTime(now.year, now.month, 9),
//         paymentMode: PaymentMode.card,
//       ),
//       TransactionModel(
//         id: 'seed_expense_7',
//         title: 'Movie Tickets',
//         type: TransactionType.expense,
//         amount: 80,
//         category: 'Entertainment',
//         date: DateTime(now.year, now.month, 12),
//         paymentMode: PaymentMode.upi,
//       ),
//       TransactionModel(
//         id: 'seed_expense_8',
//         title: 'Doctor Visit',
//         type: TransactionType.expense,
//         amount: 250,
//         category: 'Health',
//         date: DateTime(now.year, now.month, 14),
//         paymentMode: PaymentMode.cash,
//       ),
//       TransactionModel(
//         id: 'seed_expense_9',
//         title: 'Coffee Shop',
//         type: TransactionType.expense,
//         amount: 50,
//         category: 'Food',
//         date: DateTime(now.year, now.month, 16),
//         paymentMode: PaymentMode.card,
//       ),
//       TransactionModel(
//         id: 'seed_expense_10',
//         title: 'Stationery',
//         type: TransactionType.expense,
//         amount: 75,
//         category: 'Others',
//         date: DateTime(now.year, now.month, 18),
//         paymentMode: PaymentMode.cash,
//       ),
//     ];

//     // Add all sample transactions
//     for (final transaction in sampleTransactions) {
//       await _txRepo.add(transaction);
//     }

//     print('✅ Sample data seeded successfully!');
//   }
// }
