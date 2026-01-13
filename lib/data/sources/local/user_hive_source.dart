import 'package:cointrail/common/widgets/logs.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../models/user_model.dart';

class UserHiveSource {
  static const _boxName = 'userBox';

  Box<UserModel> get _box => Hive.box<UserModel>(_boxName);

  Future<void> saveUser(UserModel user) async {
    await _box.put('user', user); // ✅ store object directly
    logGreen('User saved to Hive: ${user.username}');
  }

  Future<UserModel?> getUser() async {
    try {
      return _box.get('user');
    } catch (e) {
      // If there's a type error, it means old Map data exists
      // Clear the invalid data and return null
      debugPrint('Invalid user data found in Hive, clearing it: $e');
      await _box.delete('user');
      return null;
    }
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
