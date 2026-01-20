import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

@HiveType(typeId: 3)
enum PaymentMode {
  @HiveField(0)
  cash,

  @HiveField(1)
  card,

  @HiveField(2)
  upi,

  @HiveField(3)
  bank,
}

@HiveType(typeId: 4)
class TransactionModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final TransactionType type;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final PaymentMode paymentMode;

  @HiveField(7)
  final String? note;

  @HiveField(8)
  final String? receiptPath;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.paymentMode = PaymentMode.cash,
    this.note,
    this.receiptPath,
  });

  bool get isIncome => type == TransactionType.income;

  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
