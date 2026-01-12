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

  /// Update username everywhere
  Future<void> updateUserName(String name) async {
    final user = await _local.getUser();
    if (user == null) return;

    final updated = user.copyWith(username: name);

    // 1️⃣ Save locally (instant UX)
    await _local.saveUser(updated);

    // 2️⃣ Save remotely (Firebase)
    await _remote.updateUserName(updated.id, name);
  }
}
