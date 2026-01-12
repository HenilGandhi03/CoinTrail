import 'package:hive/hive.dart';

class SettingsHiveSource {
  static const _boxName = 'settingsBox';
  static const _budgetKey = 'monthlyBudget';
  static const _nameKey = 'fullName';
  static const _darkModeKey = 'darkMode';

  Future<void> saveBudget(double budget) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_budgetKey, budget);
  }

  Future<double> getBudget() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_budgetKey, defaultValue: 3500.0);
  }

  Future<void> saveUserName(String name) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_nameKey, name);
  }

  Future<String?> getUserName() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_nameKey);
  }

  Future<void> saveDarkMode(bool value) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_darkModeKey, value);
  }

  Future<bool> getDarkMode() async {
    final box = await Hive.openBox(_boxName);
    return box.get(_darkModeKey, defaultValue: false);
  }
}
