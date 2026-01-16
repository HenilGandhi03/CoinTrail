import 'package:cointrail/app/navigator_key.dart';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/category_repository.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionController extends ChangeNotifier {
  AddTransactionController(
    this._repository,
    this._categoryRepository,
    this.existingTransaction,
  ) {
    _init();
  }
  void _init() {
    if (existingTransaction != null) {
      final tx = existingTransaction!;

      type = tx.type;
      selectedDate = tx.date;
      paymentMode = tx.paymentMode;
      paymentModeController.text = _paymentModeToText(tx.paymentMode);
      receiptPath = tx.receiptPath;

      titleController.text = tx.title;
      amountController.text = tx.amount.toStringAsFixed(0);
      noteController.text = tx.note ?? '';
    }

    loadCategories();
  }

  final TextEditingController paymentModeController = TextEditingController(
    text: 'Cash',
  );

  final TransactionRepository _repository;
  final CategoryRepository _categoryRepository;
  final TransactionModel? existingTransaction;
  bool get isEdit => existingTransaction != null;

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
  final ImagePicker _picker = ImagePicker();

  Future<void> pickReceipt() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: navigatorKey.currentContext!, // explained below
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      receiptPath = image.path;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    categories = isIncome
        ? await _categoryRepository.getIncomeCategories()
        : await _categoryRepository.getExpenseCategories();

    if (existingTransaction != null) {
      selectedCategory = categories
          .where((c) => c.name == existingTransaction!.category)
          .cast<CategoryModel?>()
          .firstOrNull;
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
    paymentMode = _parsePaymentMode(paymentModeController.text);

    final transaction = TransactionModel(
      id: isEdit
          ? existingTransaction!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
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

PaymentMode _parsePaymentMode(String text) {
  switch (text.trim().toLowerCase()) {
    case 'upi':
      return PaymentMode.upi;
    case 'card':
      return PaymentMode.card;
    case 'bank':
      return PaymentMode.bank;
    case 'cash':
    default:
      return PaymentMode.cash;
  }
}

String _paymentModeToText(PaymentMode mode) {
  switch (mode) {
    case PaymentMode.upi:
      return 'UPI';
    case PaymentMode.card:
      return 'Card';
    case PaymentMode.bank:
      return 'Bank';
    case PaymentMode.cash:
    default:
      return 'Cash';
  }
}
