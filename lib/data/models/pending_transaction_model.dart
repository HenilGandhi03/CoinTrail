import 'package:hive/hive.dart';
import 'transaction_model.dart';

part 'pending_transaction_model.g.dart';

@HiveType(typeId: 10)
class PendingTransaction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final TransactionType type;

  @HiveField(4)
  final PaymentMode paymentMode;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String rawSms;

  PendingTransaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.type,
    required this.paymentMode,
    required this.date,
    required this.rawSms,
  });
}
