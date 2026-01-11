import 'dart:async';
import 'package:cointrail/data/models/category_model.dart';
import 'package:flutter/material.dart';

enum ExportType { csv, pdf }

class SettingsController extends ChangeNotifier {
  String fullName = 'Sarah Anderson';
  String imageUrl = 'https://i.pravatar.cc/300';

  double monthlyBudget = 3500;

  final nameController = TextEditingController();
  final budgetController = TextEditingController();

  Timer? _debounce;

  SettingsController() {
    nameController.text = fullName;
    budgetController.text = monthlyBudget.toStringAsFixed(0);
  }

  void updateName(String value) {
    fullName = value;
    _autoSave();
    notifyListeners();
  }

  void updateBudget(String value) {
    final parsed = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (parsed == null) return;

    monthlyBudget = parsed;
    _autoSave();
    notifyListeners();
  }

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

  final List<CategoryModel> _customCategories = [
    CategoryModel.fromUI(
      id: 'coffee',
      name: 'Coffee & Drinks',
      icon: Icons.local_cafe,
      color: Colors.orange,
    ),
    CategoryModel.fromUI(
      id: 'gym',
      name: 'Gym & Fitness',
      icon: Icons.fitness_center,
      color: Colors.green,
    ),
    CategoryModel.fromUI(
      id: 'pets',
      name: 'Pet Expenses',
      icon: Icons.pets,
      color: Colors.blue,
    ),
  ];

  List<CategoryModel> get customCategories =>
      List.unmodifiable(_customCategories);

  void addCategory(CategoryModel category) {
    _customCategories.add(category);
    notifyListeners();
  }

  void updateCategory(CategoryModel updated) {
    final index = _customCategories.indexWhere((c) => c.id == updated.id);
    if (index == -1) return;

    _customCategories[index] = updated;
    notifyListeners();
  }

  void deleteCategory(String id) {
    _customCategories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

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
