import 'package:cointrail/common/widgets/logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthFirebaseSource {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> updateUserName(String uid, String name) async {
    logGreen('Updating username for UID: $uid to "$name"');
    await _db.collection('users').doc(uid).update({'username': name});
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
