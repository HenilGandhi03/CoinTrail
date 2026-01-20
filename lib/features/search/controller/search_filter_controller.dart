// import 'package:flutter/material.dart';
// import 'package:cointrail/data/models/category_model.dart';
// import 'package:cointrail/data/models/transaction_model.dart';
// import 'package:cointrail/data/mock/home_mock_data.dart';

// class SearchFilterController extends ChangeNotifier {
//   SearchFilterController() : _allTransactions = HomeMockData.transactions;

//   // ───────── SOURCE DATA ─────────
//   final List<TransactionModel> _allTransactions;

//   // ───────── SEARCH QUERY ─────────
//   String _query = '';
//   String get query => _query;

//   void setQuery(String value) {
//     _query = value;
//     _applyFilters();
//   }

//   // ───────── CATEGORY ─────────
//   CategoryModel? selectedCategory;
//   bool showCategorySelector = false;

//   void toggleCategorySelector() {
//     showCategorySelector = !showCategorySelector;
//     notifyListeners();
//   }

//   void closeCategorySelector() {
//     showCategorySelector = false;
//     notifyListeners();
//   }

//   // ───────── DATE ─────────
//   DateTime focusedMonth = DateTime.now();
//   DateTime? rangeStart;
//   DateTime? rangeEnd;

//   bool showCalendar = false; // ✅ RESTORED

//   void toggleCalendar() {
//     showCalendar = !showCalendar;
//     notifyListeners();
//   }

//   void closeCalendar() {
//     showCalendar = false;
//     notifyListeners();
//   }

//   void setFocusedMonth(DateTime month) {
//     focusedMonth = month;
//     notifyListeners();
//   }

//   // ───────── REPORT TYPE ─────────
//   bool isExpense = true;

//   void setReportType(bool expense) {
//     isExpense = expense;
//     _applyFilters();
//   }

//   // ───────── RESULTS ─────────
//   List<TransactionModel> results = [];

//   // ───────── FILTER ENGINE ─────────
//   void _applyFilters() {
//     results = _allTransactions.where((tx) {
//       // 🔍 text search
//       if (_query.isNotEmpty) {
//         final q = _query.toLowerCase();
//         if (!tx.title.toLowerCase().contains(q) &&
//             !tx.category.toLowerCase().contains(q)) {
//           return false;
//         }
//       }

//       // 📊 type
//       if (isExpense && tx.type != TransactionType.expense) return false;
//       if (!isExpense && tx.type != TransactionType.income) return false;

//       // 🏷 category
//       if (selectedCategory != null && tx.category != selectedCategory!.name) {
//         return false;
//       }

//       // 📅 date range
//       if (rangeStart != null && tx.date.isBefore(rangeStart!)) return false;
//       if (rangeEnd != null && tx.date.isAfter(rangeEnd!)) return false;

//       return true;
//     }).toList();

//     notifyListeners();
//   }

//   // ───────── SETTERS ─────────
//   void setCategory(CategoryModel? category) {
//     selectedCategory = category;
//     _applyFilters();
//   }

//   void setDateRange(DateTime? start, DateTime? end) {
//     rangeStart = start;
//     rangeEnd = end;
//     _applyFilters();
//   }

//   // ───────── SEARCH BUTTON ─────────
//   void search() {
//     _applyFilters();
//   }

//   // ───────── CLEAR ─────────
//   void clear() {
//     _query = '';
//     selectedCategory = null;
//     rangeStart = null;
//     rangeEnd = null;
//     isExpense = true;
//     results = [];
//     notifyListeners();
//   }
// }

import 'dart:async';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SearchFilterController extends ChangeNotifier {
  SearchFilterController() {
    _load();
    _listenToHive();
  }

  final TransactionRepository _repository = TransactionRepository();

  // ───────── SOURCE DATA ─────────
  List<TransactionModel> _allTransactions = [];

  // ───────── SEARCH QUERY ─────────
  String _query = '';
  String get query => _query;

  void setQuery(String value) {
    _query = value;
    _applyFilters();
  }

  // ───────── CATEGORY ─────────
  CategoryModel? selectedCategory;
  bool showCategorySelector = false;

  void toggleCategorySelector() {
    showCategorySelector = !showCategorySelector;
    notifyListeners();
  }

  void closeCategorySelector() {
    showCategorySelector = false;
    notifyListeners();
  }

  // ───────── DATE ─────────
  DateTime focusedMonth = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;

  bool showCalendar = false;

  void toggleCalendar() {
    showCalendar = !showCalendar;
    notifyListeners();
  }

  void closeCalendar() {
    showCalendar = false;
    notifyListeners();
  }

  void setFocusedMonth(DateTime month) {
    focusedMonth = month;
    notifyListeners();
  }

  // ───────── REPORT TYPE ─────────
  bool isExpense = true;

  void setReportType(bool expense) {
    isExpense = expense;

    // Clear selected category if it doesn't match the new type
    if (selectedCategory != null) {
      // If switching to expense but selected category is income, clear it
      if (expense && selectedCategory!.isIncome) {
        selectedCategory = null;
      }
      // If switching to income but selected category is expense, clear it
      else if (!expense && !selectedCategory!.isIncome) {
        selectedCategory = null;
      }
    }

    _applyFilters();
  }

  // ───────── RESULTS ─────────
  List<TransactionModel> results = [];

  // ───────── LOAD + LISTEN ─────────
  late final StreamSubscription _hiveSub;

  void _load() {
    _allTransactions = _repository.getAllSorted();
    _applyFilters(notify: false);
  }

  void _listenToHive() {
    _hiveSub = Hive.box<TransactionModel>('transactions').watch().listen((_) {
      _load();
      notifyListeners();
    });
  }

  // ───────── FILTER ENGINE ─────────
  void _applyFilters({bool notify = true}) {
    results = _allTransactions.where((tx) {
      // 🔍 text search
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        if (!tx.title.toLowerCase().contains(q) &&
            !tx.category.toLowerCase().contains(q)) {
          return false;
        }
      }

      // 📊 type
      if (isExpense && tx.type != TransactionType.expense) return false;
      if (!isExpense && tx.type != TransactionType.income) return false;

      // 🏷 category
      if (selectedCategory != null && tx.category != selectedCategory!.name) {
        return false;
      }

      // 📅 date range
      if (rangeStart != null && tx.date.isBefore(rangeStart!)) return false;
      if (rangeEnd != null && tx.date.isAfter(rangeEnd!)) return false;

      return true;
    }).toList();

    if (notify) notifyListeners();
  }

  // ───────── SETTERS ─────────
  void setCategory(CategoryModel? category) {
    selectedCategory = category;
    _applyFilters();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    rangeStart = start;
    rangeEnd = end;
    _applyFilters();
  }

  // ───────── CLEAR ─────────
  void clear() {
    _query = '';
    selectedCategory = null;
    rangeStart = null;
    rangeEnd = null;
    isExpense = true;
    results = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _hiveSub.cancel();
    super.dispose();
  }
}
