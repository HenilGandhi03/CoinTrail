import 'dart:async';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/sources/local/category_hive_source.dart';
import 'package:cointrail/data/sources/local/settings_hive_source.dart';
import 'package:flutter/material.dart';

enum ExportType { csv, pdf }

class SettingsController extends ChangeNotifier {
  String fullName = 'Sarah Anderson';
  String imageUrl = 'https://i.pravatar.cc/300';

  double monthlyBudget = 0;
  final _settingsHive = SettingsHiveSource();

  void updateBudget(String value) {
    final parsed = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed == null) return;

    monthlyBudget = parsed;
    _settingsHive.saveBudget(parsed); // 👈 SAVE
    _autoSave();
    notifyListeners();
  }

  final nameController = TextEditingController();
  final budgetController = TextEditingController();

  Timer? _debounce;

  SettingsController() {
    _loadBudget();
    _categoryHive.seedDefaultsIfEmpty(); // 👈 ADD

    loadCategories();
  }

  Future<void> _loadBudget() async {
    monthlyBudget = await _settingsHive.getBudget();
    budgetController.text = monthlyBudget.toStringAsFixed(0);
    notifyListeners();
  }

  void updateName(String value) {
    fullName = value;
    _autoSave();
    notifyListeners();
  }

  // void updateBudget(String value) {
  //   final parsed = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
  //   if (parsed == null) return;

  //   monthlyBudget = parsed;
  //   _autoSave();
  //   notifyListeners();
  // }

  void _autoSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), saveProfile);
  }

  Future<void> saveProfile() async {
    // 🔹 MOCK SAVE FOR NOW
    debugPrint('Auto-saved: $fullName | $monthlyBudget');

    // 🔹 LATER (Firebase)
    // await FirebaseFirestore.instance
    //   .collection('users')
    //   .doc(uid)
    //   .update({...});
  }

  bool isExporting = false;

  Future<void> exportData(ExportType type) async {
    isExporting = true;
    notifyListeners();

    // 🔹 MOCK DELAY
    await Future.delayed(const Duration(seconds: 1));

    debugPrint('Exported data as ${type == ExportType.csv ? 'CSV' : 'PDF'}');

    isExporting = false;
    notifyListeners();

    // 🔹 LATER (real)
    // - Generate CSV / PDF
    // - Save to device
    // - Share / download
  }

  bool isBackupConnected = true;
  bool isSyncing = false;
  DateTime? lastBackupTime = DateTime.now().subtract(const Duration(hours: 2));

  Future<void> syncNow() async {
    if (!isBackupConnected) return;

    isSyncing = true;
    notifyListeners();

    // 🔹 MOCK SYNC DELAY
    await Future.delayed(const Duration(seconds: 2));

    lastBackupTime = DateTime.now();
    isSyncing = false;
    notifyListeners();

    debugPrint('Backup completed');
  }

  void toggleBackupConnection() {
    isBackupConnected = !isBackupConnected;
    notifyListeners();
  }

  String get lastBackupLabel {
    if (lastBackupTime == null) return 'Never backed up';

    final diff = DateTime.now().difference(lastBackupTime!);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  final _categoryHive = CategoryHiveSource();
  List<CategoryModel> customCategories = [];

  Future<void> loadCategories() async {
    customCategories = await _categoryHive.getAll();
    notifyListeners();
  }

  void addCategory(CategoryModel category) async {
    await _categoryHive.save(category);
    await loadCategories();
  }

  void deleteCategory(String id) async {
    await _categoryHive.delete(id);
    await loadCategories();
  }

  Future<void> updateCategory(CategoryModel updated) async {
    await _categoryHive.save(updated); // overwrite by id
    await loadCategories();
  }

  // List<CategoryModel> get customCategories =>
  //     List.unmodifiable(_customCategories);

  // void addCategory(CategoryModel category) {
  //   _customCategories.add(category);
  //   notifyListeners();
  // }

  // void updateCategory(CategoryModel updated) {
  //   final index = _customCategories.indexWhere((c) => c.id == updated.id);
  //   if (index == -1) return;

  //   _customCategories[index] = updated;
  //   notifyListeners();
  // }

  // void deleteCategory(String id) {
  //   _customCategories.removeWhere((c) => c.id == id);
  //   notifyListeners();
  // }

  // =====================
  // Preferences
  // =====================

  bool isDarkMode = false;
  bool pushNotificationsEnabled = true;

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();

    // 🔹 MOCK persistence
    debugPrint('Dark mode: $isDarkMode');

    // 🔹 LATER
    // Save to local storage / Firebase
  }

  void togglePushNotifications(bool value) {
    pushNotificationsEnabled = value;
    notifyListeners();

    debugPrint('Push notifications: $pushNotificationsEnabled');

    // 🔹 LATER
    // Firebase / OneSignal / FCM
  }

  @override
  void dispose() {
    _debounce?.cancel();
    nameController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
