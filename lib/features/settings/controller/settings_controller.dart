import 'dart:async';
import 'dart:io';
import 'package:cointrail/common/widgets/logs.dart';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:cointrail/data/repositories/user_repository.dart';
import 'package:cointrail/data/services/export_service.dart';
import 'package:cointrail/data/sources/local/category_hive_source.dart';
import 'package:cointrail/data/sources/local/settings_hive_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ExportType { csv, pdf }

class SettingsController extends ChangeNotifier {
  final _userRepo = UserRepository();
  final _settingsHive = SettingsHiveSource();
  final _txRepo = TransactionRepository();

  String fullName = 'Guest';
  String imageUrl = '';
  double monthlyBudget = 0;

  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  bool get isBackupConnected => _userRepo.isLoggedIn;

  Timer? _debounce;
  ThemeMode themeMode = ThemeMode.system;
  bool isDarkMode = false;

  SettingsController() {
    _init();

    _loadUser();
    _loadBudget();
    // _categoryHive.seedDefaultsIfEmpty();
    loadCategories();
  }

  Future<void> _init() async {
    await _loadUser();
    await _loadBudget();
    await _categoryHive.seedSystemCategories();
    await loadCategories();
  }

  Future<void> updateImage(String newImageUrl) async {
    imageUrl = newImageUrl;
    notifyListeners();

    await _userRepo.updateUserImage(newImageUrl);
  }

  Future<void> _loadUser() async {
    final user = await _userRepo.getCurrentUser();
    fullName = user?.username.isNotEmpty == true ? user!.username : 'Guest';
    imageUrl = user?.imageUrl.isNotEmpty == true
        ? user!.imageUrl
        : 'https://i.pravatar.cc/300';

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
    if (value.trim().isEmpty) return;
    fullName = value.trim();
    // Debounced save for Firebase (to avoid too many API calls)
    _autoSave();
    notifyListeners();

    logGreen('💾 Updated Name to Save: $fullName');
    debugPrint('💾 Immediately saved to Hive: $fullName');
  }

  void _autoSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), saveProfile);
  }

  Future<void> saveProfile() async {
    // Save to Firebase (local Hive saving is now immediate in updateName)
    await _userRepo.updateUserName(fullName);

    logGreen('Auto-saved to Firebase: $fullName | $monthlyBudget');
  }

  bool isExporting = false;

  Future<void> exportData(ExportType type) async {
    isExporting = true;
    notifyListeners();

    try {
      final transactions = _txRepo.getAllSorted();

      if (transactions.isEmpty) return;

      if (type == ExportType.csv) {
        await ExportService.exportCSV(transactions);
      } else {
        await ExportService.exportPDF(transactions);
      }
    } finally {
      isExporting = false;
      notifyListeners();
    }
  }

  // bool isBackupConnected = true;
  bool isSyncing = false;
  DateTime? lastBackupTime = DateTime.now().subtract(const Duration(hours: 2));

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

  Future<void> changePassword(BuildContext context) async {
    try {
      await _userRepo.sendPasswordReset();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send reset email')));
    }
  }

  Future<void> syncNow() async {
    if (isSyncing) return;

    isSyncing = true;
    notifyListeners();

    try {
      final user = await _userRepo.getCurrentUser();
      if (user == null) return;

      final categories = await _categoryHive.getAll();
      final settings = {'monthlyBudget': monthlyBudget, 'darkMode': isDarkMode};

      final payload = {
        'user': user.toMap(),
        'categories': categories.map((e) => e.toMap()).toList(),
        'settings': settings,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _userRepo.uploadBackup(payload);

      lastBackupTime = DateTime.now();
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> restoreFromBackup() async {
    isSyncing = true;
    notifyListeners();

    try {
      final data = await _userRepo.downloadBackup();
      if (data == null) return;

      // Restore user
      await _userRepo.restoreUser(data['user']);

      // Restore categories
      await _categoryHive.clear();
      for (final c in data['categories']) {
        await _categoryHive.save(CategoryModel.fromMap(c));
      }

      // Restore settings
      monthlyBudget = data['settings']['monthlyBudget'] ?? monthlyBudget;
      await _settingsHive.saveBudget(monthlyBudget);

      lastBackupTime = DateTime.parse(data['updatedAt']);
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  final _picker = ImagePicker();

  Future<void> pickAndUpdateProfileImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked == null) return;

    final file = File(picked.path);

    final user = await _userRepo.getCurrentUser();
    if (user == null || user.id.isEmpty) return;

    // 1️⃣ Upload to Firebase Storage
    final imageUrl = await _userRepo.uploadProfileImage(
      uid: user.id,
      file: file,
    );

    // 2️⃣ Save locally + Firestore
    await _userRepo.updateUserImage(imageUrl);

    // 3️⃣ Update UI instantly
    this.imageUrl = imageUrl;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _userRepo.logout();
    // 🔁 Navigate to login & clear stack
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    nameController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
