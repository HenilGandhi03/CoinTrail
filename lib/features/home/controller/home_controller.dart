import 'dart:async';
import 'package:cointrail/common/widgets/logs.dart';
import 'package:cointrail/data/models/expense_summary_model.dart';
import 'package:cointrail/data/models/monthly_summary_model.dart';
import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/models/user_model.dart';
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
  late final StreamSubscription _settingsSub;
  late final StreamSubscription _userSub;
  late final StreamSubscription? _pendingSub;
  TransactionModel? _lastDeleted;
  TransactionPeriod selectedPeriod = TransactionPeriod.all;

  DateTime selectedMonth = DateTime.now();

  void deleteTransaction(String id) {
    try {
      _lastDeleted = _recentTransactions.firstWhere((t) => t.id == id);
    } catch (e) {
      _lastDeleted = null;
    }
    _repository.deleteTransaction(id);
    _load();
  }

  void restoreTransaction(TransactionModel? tx) {
    if (tx != null) {
      _repository.saveTransaction(tx);
      _load();
    }
  }

  void restoreLastDeleted() {
    if (_lastDeleted != null) {
      restoreTransaction(_lastDeleted);
      _lastDeleted = null;
    }
  }

  void updateMonth(DateTime month) {
    selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void nextMonth() {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    notifyListeners();
  }

  Future<void> _init() async {
    await _load();
    await _loadUser();
    _listenToHive();
    _listenToUserBox();
    _listenToSettingsBox();
    _listenToPendingBox();
  }

  final HomeRepository _repository = HomeRepository();

  String _userName = 'Guest';
  String get userName => _userName;

  Future<void> _loadUser() async {
    _userName = await _repository.getUserName();
    debugPrint('🏠 Home controller loaded user name: $_userName');
    notifyListeners();
  }

  void _listenToUserBox() {
    _userSub = Hive.box<UserModel>('userBox').watch().listen((_) {
      logGreen('🔁 userBox changed → HomeController reloading');
      _loadUser();
    });
  }

  void _listenToSettingsBox() {
    _settingsSub = Hive.box('settingsBox').watch().listen((event) {
      if (event.key == 'monthlyBudget') {
        logGreen('🔁 Budget changed → reloading summaries');
        _load(); // reload monthly + expense summaries
      }
    });
  }

  void _listenToPendingBox() {
    try {
      // Check if box is already open
      if (Hive.isBoxOpen('pending_transactions')) {
        final subscription = Hive.box('pending_transactions').watch().listen((
          _,
        ) {
          logGreen('🔁 Pending transactions changed → notifying listeners');
          // Just notify listeners to update any pending transaction counts or badges
          notifyListeners();
        });
        _pendingSub = subscription;
      } else {
        logGreen(
          '⚠️ Pending transactions box not open, skipping listener setup',
        );
        _pendingSub = null;
      }
    } catch (e) {
      logGreen('❌ Error setting up pending box listener: $e');
      _pendingSub = null;
    }
  }

  // Manual method to refresh user name (for testing)
  Future<void> refreshUserName() async {
    debugPrint('🔄 Manually refreshing user name...');
    await _loadUser();
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

  late final StreamSubscription _hiveSubscription;
  StreamSubscription? _settingsSubscription;

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
  }

  void updatePeriod(TransactionPeriod newPeriod) {
    selectedPeriod = newPeriod;
    notifyListeners();
  }

  List<TransactionModel> getAllTransactions() {
    return _repository.getAllTransactions();
  }

  // Get pending transactions count for badges/indicators
  int get pendingTransactionsCount {
    try {
      final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
      return pendingBox.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  void dispose() {
    _hiveSubscription.cancel();
    _settingsSubscription?.cancel();
    _settingsSub.cancel();
    _userSub.cancel();
    _pendingSub?.cancel();
    super.dispose();
  }
}
