import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cointrail/common/widgets/logs.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../sources/local/user_hive_source.dart';
import '../sources/remote/auth_firebase_source.dart';

class UserRepository {
  final _local = UserHiveSource();
  final _remote = AuthFirebaseSource();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> uploadBackup(Map<String, dynamic> payload) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('backup')
        .doc('main')
        .set(payload);
  }

  Future<void> restoreUser(Map<String, dynamic> map) async {
    final user = UserModel.fromMap(map);
    await _local.saveUser(user);
  }

  Future<Map<String, dynamic>?> downloadBackup() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('backup')
        .doc('main')
        .get();

    return snap.data();
  }

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

  Future<void> sendPasswordReset() async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;

    await _auth.sendPasswordResetEmail(email: user.email!);
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
