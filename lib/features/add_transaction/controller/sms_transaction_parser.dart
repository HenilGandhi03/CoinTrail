import 'package:cointrail/data/models/transaction_model.dart';

class ParsedSmsTransaction {
  final double amount;
  final String title;
  final TransactionType type;
  final PaymentMode paymentMode;
  final DateTime date;

  ParsedSmsTransaction({
    required this.amount,
    required this.title,
    required this.type,
    required this.paymentMode,
    required this.date,
  });
}

class SmsTransactionParser {
  SmsTransactionParser._();

  static ParsedSmsTransaction? parse(String sms) {
    final text = sms.toLowerCase();

    // 1️⃣ Ignore OTP / promo / non-transaction messages
    if (_isIgnorable(text)) return null;

    // 2️⃣ Extract amount
    final amount = _extractAmount(text);
    if (amount == null) return null;

    // 3️⃣ Determine transaction type
    final type = _detectType(text);

    // 4️⃣ Detect payment mode
    final paymentMode = _detectPaymentMode(text);

    // 5️⃣ Extract merchant / title
    final title = _extractTitle(sms);

    return ParsedSmsTransaction(
      amount: amount,
      title: title,
      type: type,
      paymentMode: paymentMode,
      date: DateTime.now(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────

  static bool _isIgnorable(String text) {
    const ignoreKeywords = [
      'otp',
      'one time password',
      'verification',
      'offer',
      'cashback',
      'reward',
      'promo',
    ];

    return ignoreKeywords.any(text.contains);
  }

  static double? _extractAmount(String text) {
    final regex = RegExp(
      r'(rs\.?|inr|₹)\s?([\d,]+(?:\.\d+)?)',
      caseSensitive: false,
    );

    final match = regex.firstMatch(text);
    if (match == null) return null;

    final raw = match.group(2)!.replaceAll(',', '');
    return double.tryParse(raw);
  }

  static TransactionType _detectType(String text) {
    const debitKeywords = [
      'debit',
      'debited',
      'spent',
      'paid',
      'purchase',
      'withdrawn',
    ];

    return debitKeywords.any(text.contains)
        ? TransactionType.expense
        : TransactionType.income;
  }

  static PaymentMode _detectPaymentMode(String text) {
    if (text.contains('upi')) return PaymentMode.upi;
    if (text.contains('card')) return PaymentMode.card;
    if (text.contains('cash')) return PaymentMode.cash;
    return PaymentMode.bank;
  }

  static String _extractTitle(String sms) {
    // common patterns: "to Swiggy", "at Amazon", "from HDFC"
    final regex = RegExp(r'(?:to|at|from)\s+([A-Za-z0-9 &._-]{3,})');

    final match = regex.firstMatch(sms);
    if (match != null) {
      return match.group(1)!.trim();
    }

    return 'Bank Transaction';
  }

  /// Generate a unique ID for a transaction based on its content
  /// This helps prevent duplicates by creating consistent IDs for similar transactions
  static String generateTransactionId({
    required double amount,
    required String title,
    required DateTime date,
    required String rawSms,
  }) {
    // Create a unique signature based on content and SMS hash
    final content =
        '${amount}_${title}_${date.millisecondsSinceEpoch ~/ 3600000}'; // Hour precision
    final smsHash = rawSms.hashCode.abs().toString();
    return '${content}_$smsHash';
  }
}
