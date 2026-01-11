enum TransactionType { income, expense }

enum PaymentMode { cash, card, upi, bank }

class TransactionModel {
  final String id;
  final String title;
  final TransactionType type;
  final double amount;
  final String category;
  final DateTime date;
  final PaymentMode paymentMode;
  final String? note;
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

  // ----------------------------------------
  // Derived / computed properties
  // ----------------------------------------

  bool get isIncome => type == TransactionType.income;

  String get formattedDate {
    // Simple, clean format for home screen
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}


