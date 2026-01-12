import 'package:hive_flutter/hive_flutter.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(CategoryModelAdapter())
      ..registerAdapter(TransactionTypeAdapter())
      ..registerAdapter(PaymentModeAdapter())
      ..registerAdapter(TransactionModelAdapter())
      ..registerAdapter(UserModelAdapter());

    await Hive.openBox<CategoryModel>('categories');
    await Hive.openBox<TransactionModel>('transactions');
    await Hive.openBox<UserModel>('user');
  }

  // Enhanced debugging method
  static void debugCategories() {
    print('=== DEBUG CATEGORIES START ===');

    try {
      // Check if Hive is initialized
      if (!Hive.isBoxOpen('categories')) {
        print('Categories box is not open!');
        return;
      }

      final box = Hive.box<CategoryModel>('categories');
      print('Box is open: ${box.isOpen}');
      print('Total categories: ${box.length}');
      print('Box keys: ${box.keys.toList()}');
      print('All categories: ${box.values.toList()}');

      // Check if box is empty
      if (box.isEmpty) {
        print('Categories box is empty!');
      }

      // Print individual categories
      for (var category in box.values) {
        print(
          'Category: ${category.name}, ID: ${category.id}, isIncome: ${category.isIncome}',
        );
      }
    } catch (e) {
      print('Error accessing categories box: $e');
    }

    print('=== DEBUG CATEGORIES END ===');
  }

  // Method to check if boxes are properly initialized
  static void debugHiveStatus() {
    print('=== HIVE STATUS ===');
    print('Categories box open: ${Hive.isBoxOpen('categories')}');
    print('Transactions box open: ${Hive.isBoxOpen('transactions')}');
    print('User box open: ${Hive.isBoxOpen('user')}');
  }
}
