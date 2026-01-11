import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/category_repository.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

// class AddTransactionController extends ChangeNotifier {
//   AddTransactionController(this._repository, this._categoryRepository);

//   final TransactionRepository _repository;
//   final CategoryRepository _categoryRepository;

//   // ───────── TYPE ─────────
//   TransactionType type = TransactionType.income;
//   bool get isIncome => type == TransactionType.income;

//   void toggleType(bool income) {
//     type = income ? TransactionType.income : TransactionType.expense;
//     selectedCategory = null;
//     notifyListeners();
//   }

//   // ───────── DATE ─────────
//   DateTime selectedDate = DateTime.now();

//   /// Move by week (±7 days)
//   void changeWeek(int offset) {
//     final candidate = selectedDate.add(Duration(days: 7 * offset));

//     // Block future weeks
//     if (candidate.isAfter(DateTime.now())) return;

//     selectedDate = candidate;
//     notifyListeners();
//   }

//   /// Set specific day
//   void setDate(DateTime date) {
//     // Block future days
//     if (date.isAfter(DateTime.now())) return;

//     selectedDate = date;
//     notifyListeners();
//   }

//   // ───────── CATEGORY ─────────
//   CategoryModel? selectedCategory;
//   List<CategoryModel> categories = [];

//   void setCategory(CategoryModel category) {
//     selectedCategory = category;
//     notifyListeners();
//   }

//   // ───────── PAYMENT ─────────
//   PaymentMode paymentMode = PaymentMode.cash;

//   void setPaymentMode(PaymentMode mode) {
//     paymentMode = mode;
//     notifyListeners();
//   }

//   // ───────── INPUTS ─────────
//   final titleController = TextEditingController();
//   final amountController = TextEditingController();
//   final noteController = TextEditingController();

//   String? receiptPath;

//   void setReceipt(String path) {
//     receiptPath = path;
//     notifyListeners();
//   }

//   // ───────── SAVE ─────────
//   Future<void> saveTransaction() async {
//     if (titleController.text.isEmpty ||
//         amountController.text.isEmpty ||
//         selectedCategory == null) {
//       throw Exception('Missing required fields');
//     }

//     final transaction = TransactionModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: titleController.text.trim(),
//       type: type,
//       amount: double.parse(amountController.text),
//       category: selectedCategory!.name,
//       date: selectedDate,
//       paymentMode: paymentMode,
//       note: noteController.text.isEmpty ? null : noteController.text,
//       receiptPath: receiptPath,
//     );

//     await _repository.add(transaction);
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     amountController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }
// }

class AddTransactionController extends ChangeNotifier {
  AddTransactionController(this._repository, this._categoryRepository) {
    loadCategories();
  }

  final TransactionRepository _repository;
  final CategoryRepository _categoryRepository;

  TransactionType type = TransactionType.income;
  bool get isIncome => type == TransactionType.income;

  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;

  DateTime selectedDate = DateTime.now();
  PaymentMode paymentMode = PaymentMode.cash;

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String? receiptPath;

  // ───────── CATEGORY ─────────
  Future<void> loadCategories() async {
    categories = isIncome
        ? await _categoryRepository.getIncomeCategories()
        : await _categoryRepository.getExpenseCategories();
    if (selectedCategory != null &&
        !categories.any((c) => c.id == selectedCategory!.id)) {
      selectedCategory = null;
    }

    notifyListeners();
  }

  void toggleType(bool income) {
    type = income ? TransactionType.income : TransactionType.expense;
    selectedCategory = null;
    loadCategories();
  }

  void setCategory(CategoryModel category) {
    selectedCategory = category;
    notifyListeners();
  }

  // ───────── DATE ─────────
  void changeWeek(int offset) {
    final candidate = selectedDate.add(Duration(days: 7 * offset));
    if (candidate.isAfter(DateTime.now())) return;
    selectedDate = candidate;
    notifyListeners();
  }

  void setDate(DateTime date) {
    if (date.isAfter(DateTime.now())) return;
    selectedDate = date;
    notifyListeners();
  }

  // ───────── PAYMENT ─────────
  void setPaymentMode(PaymentMode mode) {
    paymentMode = mode;
    notifyListeners();
  }

  void setReceipt(String path) {
    receiptPath = path;
    notifyListeners();
  }

  // ───────── SAVE ─────────
  Future<void> saveTransaction() async {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedCategory == null) {
      throw Exception('Missing required fields');
    }

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      type: type,
      amount: double.parse(amountController.text),
      category: selectedCategory!.name,
      date: selectedDate,
      paymentMode: paymentMode,
      note: noteController.text.isEmpty ? null : noteController.text,
      receiptPath: receiptPath,
    );

    await _repository.add(transaction);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
