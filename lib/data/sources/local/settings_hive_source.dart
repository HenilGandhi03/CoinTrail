import 'package:hive/hive.dart';

class SettingsHiveSource {
  static const _boxName = 'settingsBox';
  static const _budgetKey = 'monthlyBudget';

  Future<void> saveBudget(double budget) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_budgetKey, budget);
  }

  Future<double> getBudget() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_budgetKey, defaultValue: 3500.0);
  }
}
