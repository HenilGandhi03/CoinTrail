import 'dart:async';
import 'package:cointrail/data/models/expense_summary_model.dart';
import 'package:cointrail/data/models/monthly_summary_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/home_repository.dart';
import 'package:cointrail/features/home/widgets/horizontal_header.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    _init();
  }
  MonthlySummaryModel? _monthlySummary;
  ExpenseSummaryModel? _expenseSummary;

  Future<void> _init() async {
    await _load();
    await _loadUser();
    _listenToHive();
  }

  final HomeRepository _repository = HomeRepository();

  String _userName = '—';
  String get userName => _userName;

  Future<void> _loadUser() async {
    _userName = await _repository.getUserName();
    notifyListeners();
  }

  List<TransactionModel> _recentTransactions = [];

  List<TransactionModel> get recentTransactions =>
      List.unmodifiable(_recentTransactions);

  // get monthlySummary => _repository.getMonthlySummary();
  get categories => _repository.getCategories();
  // get expenseSummary => _repository.getExpenseSummary();
  get incomeSummary => _repository.getIncomeSummary();
  MonthlySummaryModel get monthlySummary =>
      _monthlySummary ??
      MonthlySummaryModel(totalSpent: 0, budget: 0, daysLeft: 0);

  ExpenseSummaryModel get expenseSummary =>
      _expenseSummary ??
      ExpenseSummaryModel(
        totalExpense: 0,
        today: 0,
        categories: 0,
        budget: 0,
        progress: 0,
      );

  var selectedPeriod = TransactionPeriod.daily;

  late final StreamSubscription _hiveSubscription;

  Future<void> _load() async {
    _recentTransactions = _repository.getRecentTransactions(limit: 5);

    _monthlySummary = await _repository.getMonthlySummary();
    _expenseSummary = await _repository.getExpenseSummary();

    notifyListeners();
  }

  void _listenToHive() {
    _hiveSubscription = Hive.box<TransactionModel>(
      'transactions',
    ).watch().listen((_) => _load());
    Hive.box('settingsBox').watch().listen((_) => _load()); // 👈 ADD THIS LINE
  }

  void updatePeriod(TransactionPeriod newPeriod) {
    selectedPeriod = newPeriod;
    notifyListeners();
  }

  List<TransactionModel> getAllTransactions() {
    return _repository.getAllTransactions();
  }

  @override
  void dispose() {
    _hiveSubscription.cancel();
    super.dispose();
  }
}
