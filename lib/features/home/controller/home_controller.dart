import 'package:cointrail/data/mock/home_mock_data.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/home_repository.dart';
import 'package:cointrail/features/home/widgets/horizontal_header.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();

  String get userName => _repository.getUserName();

  get monthlySummary => _repository.getMonthlySummary();

  get categories => _repository.getCategories();

  get recentTransactions => _repository.getRecentTransactions();
  get expenseSummary => _repository.getExpenseSummary();

  get incomeSummary => _repository.getIncomeSummary();

  var selectedPeriod = TransactionPeriod.daily;

  void updatePeriod(TransactionPeriod newPeriod) {
    selectedPeriod = newPeriod;
    notifyListeners(); // This triggers rebuild
  }

  List<TransactionModel> getAllTransactions() {
    return List.unmodifiable(HomeMockData.transactions);
  }

  void addTransaction(TransactionModel transaction) {
    _repository.addTransaction(transaction);
    notifyListeners();
  }
}
