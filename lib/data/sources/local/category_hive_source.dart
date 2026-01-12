import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/category_model.dart';

class CategoryHiveSource {
  static const _boxName = 'categories';

  Future<Box<CategoryModel>> _box() async {
    return Hive.box<CategoryModel>(_boxName);
  }

  Future<List<CategoryModel>> getAll() async {
    final box = await _box();
    return box.values.toList();
  }

  Future<List<CategoryModel>> getExpenses() async {
    final box = await _box();
    return box.values.where((c) => !c.isIncome).toList();
  }

  Future<List<CategoryModel>> getIncome() async {
    final box = await _box();
    return box.values.where((c) => c.isIncome).toList();
  }

  Future<void> save(CategoryModel category) async {
    final box = await _box();
    await box.put(category.id, category);
  }

  Future<void> delete(String id) async {
    final box = await _box();
    await box.delete(id);
  }

  Future<void> seedDefaultsIfEmpty() async {
    Future<void> seedDefaultsIfEmpty() async {
      final box = await _box(); // ✅ reuse
      if (box.isNotEmpty) return;
      if (box.isNotEmpty) return;

      final defaults = [
        CategoryModel.fromUI(
          id: 'food',
          name: 'Food',
          icon: Icons.restaurant,
          color: Colors.red,
        ),
        CategoryModel.fromUI(
          id: 'transport',
          name: 'Transport',
          icon: Icons.directions_car,
          color: Colors.blue,
        ),
        CategoryModel.fromUI(
          id: 'salary',
          name: 'Salary',
          icon: Icons.work,
          color: Colors.green,
          isIncome: true,
        ),
      ];

      for (final c in defaults) {
        await box.put(c.id, c);
      }
    }
  }
}
