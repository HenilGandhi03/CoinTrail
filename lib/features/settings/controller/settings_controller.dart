import 'dart:async';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/repositories/user_repository.dart';
import 'package:cointrail/data/sources/local/category_hive_source.dart';
import 'package:cointrail/data/sources/local/settings_hive_source.dart';
import 'package:flutter/material.dart';

enum ExportType { csv, pdf }

class SettingsController extends ChangeNotifier {
  final _userRepo = UserRepository();
  final _settingsHive = SettingsHiveSource();

  String fullName = 'Guest';
  String imageUrl = 'https://i.pravatar.cc/300';
  double monthlyBudget = 0;

  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  Timer? _debounce;
  ThemeMode themeMode = ThemeMode.system;
  bool isDarkMode = false;

  SettingsController() {
    _init();

    _loadUser();
    _loadBudget();
    _categoryHive.seedDefaultsIfEmpty(); // 👈 ADD
    loadCategories();
  }

  Future<void> _init() async {
    await _loadUser();
    await _loadBudget();
    // await _loadTheme();
    await _categoryHive.seedDefaultsIfEmpty();
    await loadCategories();
  }

  Future<void> _loadUser() async {
    final user = await _userRepo.getCurrentUser();
    fullName = user?.username.isNotEmpty == true ? user!.username : 'User';
    nameController.text = fullName;

    debugPrint("Settings fullName: $fullName");
    notifyListeners();
  }

  void updateBudget(String value) {
    final parsed = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed == null) return;

    monthlyBudget = parsed;
    _settingsHive.saveBudget(parsed);
    _autoSave();
    notifyListeners();
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

  void _autoSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), saveProfile);
  }

  Future<void> saveProfile() async {
    // 1️⃣ Save locally (instant)
    await _settingsHive.saveUserName(fullName);

    // 2️⃣ Save to Firebase
    await _userRepo.updateUserName(fullName);

    debugPrint('Auto-saved: $fullName | $monthlyBudget');
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

  // =====================
  // Preferences
  // =====================

  bool pushNotificationsEnabled = true;

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    // notifyListeners();

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
