import 'dart:io';

import 'package:cointrail/common/widgets/logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/user_model.dart';

class AuthFirebaseSource {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> updateUserName(String uid, String name) async {
    logGreen('Updating username for UID: $uid to "$name"');
    await _db.collection('users').doc(uid).update({'username': name});
  }

  Future<void> updateUserImage(String uid, String imageUrl) async {
    await _db.collection('users').doc(uid).update({'imageUrl': imageUrl});
  }

  Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$uid.jpg');

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw Exception('Failed to create user account');
    }

    final user = UserModel(
      id: credential.user!.uid,
      email: email,
      username: username,
      imageUrl: 'https://i.pravatar.cc/300',
    );

    await _db.collection('users').doc(user.id).set({
      ...user.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw Exception('Failed to sign in user');
    }

    final docRef = _db.collection('users').doc(credential.user!.uid);
    final snap = await docRef.get();

    // ✅ Safety fallback
    if (!snap.exists || snap.data() == null) {
      final fallbackUser = UserModel(
        id: credential.user!.uid,
        email: credential.user!.email ?? email,
        username: '',
        imageUrl: 'https://i.pravatar.cc/300',
      );

      await docRef.set(fallbackUser.toMap());

      return fallbackUser;
    }

    return UserModel.fromMap(snap.data()!);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
