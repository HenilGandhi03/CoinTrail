
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryMockData {
  static final List<CategoryModel> expenseCategories = [
    CategoryModel.fromUI(
      id: 'food',
      name: 'Food',
      icon: Icons.restaurant_rounded,
      color: const Color(0xFFEF4444),
    ),
    CategoryModel.fromUI(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car_rounded,
      color: const Color(0xFF3B82F6),
    ),
    CategoryModel.fromUI(
      id: 'bills',
      name: 'Bills',
      icon: Icons.receipt_long_rounded,
      color: const Color(0xFF22C55E),
    ),
    CategoryModel.fromUI(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: const Color(0xFFF59E0B),
    ),
    CategoryModel.fromUI(
      id: 'others',
      name: 'Others',
      icon: Icons.more_horiz_rounded,
      color: const Color(0xFF9CA3AF),
    ),
  ];

  static final List<CategoryModel> incomeCategories = [
    CategoryModel.fromUI(
      id: 'salary',
      name: 'Salary',
      icon: Icons.work_rounded,
      color: const Color(0xFF10B981),
      isIncome: true,
    ),
    CategoryModel.fromUI(
      id: 'freelance',
      name: 'Freelance',
      icon: Icons.laptop_mac_rounded,
      color: const Color(0xFF6366F1),
      isIncome: true,
    ),
  ];

  static List<CategoryModel> get all => [
    ...expenseCategories,
    ...incomeCategories,
  ];
}
