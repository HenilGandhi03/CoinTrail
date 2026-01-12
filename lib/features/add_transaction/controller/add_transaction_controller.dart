import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/category_repository.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

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
    print(
      'AddTransactionController: Loading categories for isIncome=$isIncome',
    );

    categories = isIncome
        ? await _categoryRepository.getIncomeCategories()
        : await _categoryRepository.getExpenseCategories();

    print('AddTransactionController: Loaded ${categories.length} categories');
    for (var category in categories) {
      print(
        '  - ${category.name} (${category.id}) isIncome=${category.isIncome}',
      );
    }

    if (selectedCategory != null &&
        !categories.any((c) => c.id == selectedCategory!.id)) {
      selectedCategory = null;
      print(
        'AddTransactionController: Reset selectedCategory because it was not found',
      );
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
