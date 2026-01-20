import 'package:hive/hive.dart';

part 'activity_log_model.g.dart';

@HiveType(typeId: 11)
class ActivityLog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;

  ActivityLog({
    required this.id,
    required this.message,
    required this.timestamp,
  });
}
