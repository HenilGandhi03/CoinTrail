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
}
