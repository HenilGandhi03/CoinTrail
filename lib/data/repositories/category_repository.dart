
// lib/data/repositories/category_repository.dart
import '../models/category_model.dart';
import '../sources/local/category_hive_source.dart';

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
