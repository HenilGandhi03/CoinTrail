// backup_payload.dart
class BackupPayload {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> transactions;
  final Map<String, dynamic> settings;

  BackupPayload({
    required this.user,
    required this.categories,
    required this.transactions,
    required this.settings,
  });

  Map<String, dynamic> toMap() => {
    'user': user,
    'categories': categories,
    'transactions': transactions,
    'settings': settings,
    'updatedAt': DateTime.now().toIso8601String(),
  };
}
