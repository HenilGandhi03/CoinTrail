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

  Future<void> seedSystemCategories() async {
    final box = await _box();

    final defaults = [
      CategoryModel.fromUI(
        id: 'food',
        name: 'Food',
        icon: Icons.restaurant_rounded,
        color: const Color(0xFFEF4444),
        isSystem: true,
      ),
      CategoryModel.fromUI(
        id: 'transport',
        name: 'Transport',
        icon: Icons.directions_car_rounded,
        color: const Color(0xFF3B82F6),
        isSystem: true,
      ),
      CategoryModel.fromUI(
        id: 'bills',
        name: 'Bills',
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFF22C55E),
        isSystem: true,
      ),
      CategoryModel.fromUI(
        id: 'shopping',
        name: 'Shopping',
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFFF59E0B),
        isSystem: true,
      ),
      CategoryModel.fromUI(
        id: 'others',
        name: 'Others',
        icon: Icons.more_horiz_rounded,
        color: const Color(0xFF9CA3AF),
        isSystem: true,
      ),
      CategoryModel.fromUI(
        id: 'salary',
        name: 'Salary',
        icon: Icons.work_rounded,
        color: const Color(0xFF10B981),
        isIncome: true,
        isSystem: true,
      ),
      CategoryModel.fromUI(
        id: 'freelance',
        name: 'Freelance',
        icon: Icons.laptop_mac_rounded,
        color: const Color(0xFF6366F1),
        isIncome: true,
        isSystem: true,
      ),
    ];

    for (final c in defaults) {
      if (!box.containsKey(c.id)) {
        await box.put(c.id, c);
      }
    }
  }
}
