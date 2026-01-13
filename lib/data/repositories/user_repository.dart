import 'dart:io';

import 'package:cointrail/common/widgets/logs.dart';

import '../models/user_model.dart';
import '../sources/local/user_hive_source.dart';
import '../sources/remote/auth_firebase_source.dart';

class UserRepository {
  final _local = UserHiveSource();
  final _remote = AuthFirebaseSource();

  /// Get cached user (Hive)
  Future<UserModel?> getCurrentUser() {
    return _local.getUser();
  }

  Future<String> uploadProfileImage({required String uid, required File file}) {
    return _remote.uploadProfileImage(uid: uid, file: file);
  }

  Future<void> logout() async {
    // 1️⃣ Firebase sign out
    await _remote.logout();

    // 2️⃣ Clear local user cache
    await _local.clear();
  }

  /// Update username everywhere
  Future<void> updateUserName(String name) async {
    final user = await _local.getUser();

    if (user == null) {
      logGreen('⚠️ No user found in Hive, skipping update');
      return;
    }

    final updated = user.copyWith(username: name);

    // 1️⃣ Save locally (ALWAYS)
    await _local.saveUser(updated);

    logGreen('💾 User name updated in local to: $name');
    // 2️⃣ Save remotely (Firebase)
    await _remote.updateUserName(updated.id, name);
  }

  Future<void> updateUserImage(String imageUrl) async {
    final user = await _local.getUser();
    if (user == null) return;

    final updated = user.copyWith(imageUrl: imageUrl);

    // 1️⃣ Save locally (instant)
    await _local.saveUser(updated);

    // 2️⃣ Save remotely (Firebase)
    if (updated.id.isNotEmpty) {
      await _remote.updateUserImage(updated.id, imageUrl);
    }
  }
}
