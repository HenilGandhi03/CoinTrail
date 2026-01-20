import 'package:hive/hive.dart';

part 'app_notification_model.g.dart';

@HiveType(typeId: 12)
class AppNotification {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
  });
}
