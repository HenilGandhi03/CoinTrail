// class UserModel {
//   final String id;
//   final String email;
//   final String username;

//   const UserModel({
//     required this.id,
//     required this.email,
//     required this.username,
//   });

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] ?? '',
//       email: map['email'] ?? '',
//       username: map['username'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'email': email, 'username': username};
//   }
// }

import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 5)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'username': username};
  }

  copyWith({required String username}) {}
}
