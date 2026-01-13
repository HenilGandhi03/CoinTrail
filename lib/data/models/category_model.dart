// import 'package:flutter/material.dart';

// class CategoryModel {
//   final String id;
//   final String name;
//   final IconData icon;
//   final Color color;
//   final bool isIncome;

//   const CategoryModel({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.color,
//     this.isIncome = false,
//   });
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCode;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final bool isIncome;
  
  @HiveField(5)
  final bool isSystem; 

  // ✅ Hive-compatible constructor
  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorValue,
    required this.isSystem,

    this.isIncome = false,
  });

  // ✅ UI helpers (derived, NOT stored)
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  Color get color => Color(colorValue);

  // ✅ Optional factory for UI-friendly creation
  factory CategoryModel.fromUI({
    required String id,
    required String name,
    required IconData icon,
    required Color color,
    bool isIncome = false,
    bool isSystem = false,
  }) {
    return CategoryModel(
      id: id,
      name: name,
      iconCode: icon.codePoint,
      colorValue: color.toARGB32(),
      isIncome: isIncome,
      isSystem: isSystem,
    );
  }
}
