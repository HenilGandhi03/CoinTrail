// import 'package:cointrail/data/models/category_model.dart';
// import 'package:cointrail/data/sources/local/category_hive_source.dart';
// import '../mock/category_mock_data.dart';

// class CategoryRepository {
//   final _hive = CategoryHiveSource();

//   /// Expense categories (default + custom)
//   Future<List<CategoryModel>> getExpenseCategories() async {
//     final custom = await _hive.getAll();

//     return [
//       ...CategoryMockData.expenseCategories,
//       ...custom.where((c) => !c.isIncome),
//     ];
//   }

//   /// Income categories (default + custom)
//   Future<List<CategoryModel>> getIncomeCategories() async {
//     final custom = await _hive.getAll();

//     return [
//       ...CategoryMockData.incomeCategories,
//       ...custom.where((c) => c.isIncome),
//     ];
//   }

//   /// All categories
//   Future<List<CategoryModel>> getAllCategories() async {
//     final custom = await _hive.getAll();

//     return [...CategoryMockData.all, ...custom];
//   }
// }

// lib/data/repositories/category_repository.dart
import '../models/category_model.dart';
import '../sources/local/category_hive_source.dart';
import '../mock/category_mock_data.dart';

class CategoryRepository {
  final _hive = CategoryHiveSource();

  Future<List<CategoryModel>> getExpenseCategories() async {
    return await _hive.getExpenses();
  }

  Future<List<CategoryModel>> getIncomeCategories() async {
    return await _hive.getIncome();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    return await _hive.getAll();
  }
}
