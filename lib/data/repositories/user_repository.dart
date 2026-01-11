import '../models/user_model.dart';
import '../sources/local/user_hive_source.dart';

class UserRepository {
  final _local = UserHiveSource();

  Future<UserModel?> getCurrentUser() {
    return _local.getUser();
  }
}
