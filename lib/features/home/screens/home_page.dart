import 'dart:async';
import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/services/native_sms_service.dart';
import 'package:cointrail/data/services/pending_transaction_service.dart';
import 'package:cointrail/features/add_transaction/controller/sms_transaction_parser.dart';
import 'package:cointrail/features/home/widgets/header/home_header.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transactions_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Timer? _smsPollingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
    _startPeriodicSmsPolling();
  }

  @override
  void dispose() {
    _smsPollingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncPendingSms();
    }
  }

  void _startPeriodicSmsPolling() {
    // Poll for new SMS every 10 seconds when app is active
    _smsPollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _syncPendingSms();
      }
    });
  }

  Future<void> _init() async {
    await requestSmsPermission();

    // Clean up old pending transactions (7+ days old)
    await PendingTransactionService.cleanupOldPendingTransactions();

    await _syncPendingSms();
  }

  Future<void> _syncPendingSms() async {
    debugPrint('🟡 _syncPendingSms CALLED');

    final rawSmsList = await NativeSmsService.getPendingSms();
    debugPrint('🟡 Native SMS count: ${rawSmsList.length}');
    debugPrint('🟡 Native SMS content: $rawSmsList');

    if (rawSmsList.isEmpty) return;

    final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
    final transactionBox = Hive.box<TransactionModel>('transactions');

    // Track if we added any new transactions
    bool hasNewTransactions = false;

    for (final sms in rawSmsList) {
      debugPrint('🟡 Parsing SMS: $sms');

      final parsed = SmsTransactionParser.parse(sms);
      debugPrint('🟡 Parsed result: $parsed');

      if (parsed == null) continue;

      // Enhanced duplicate checking
      if (_isDuplicateTransaction(parsed, sms, pendingBox, transactionBox)) {
        debugPrint('🟡 Duplicate transaction detected, skipping');
        continue;
      }

      // Generate unique ID based on transaction content
      final uniqueId = SmsTransactionParser.generateTransactionId(
        amount: parsed.amount,
        title: parsed.title,
        date: parsed.date,
        rawSms: sms,
      );

      // Check if this exact transaction already exists (by unique ID)
      if (pendingBox.containsKey(uniqueId) ||
          transactionBox.containsKey(uniqueId)) {
        debugPrint('🟡 Transaction with unique ID already exists: $uniqueId');
        continue;
      }

      final pending = PendingTransaction(
        id: uniqueId, // Use content-based ID instead of timestamp
        amount: parsed.amount,
        title: parsed.title,
        type: parsed.type,
        paymentMode: parsed.paymentMode,
        date: parsed.date,
        rawSms: sms,
      );

      pendingBox.put(pending.id, pending);
      hasNewTransactions = true;
      debugPrint('🟢 New pending transaction saved to Hive');

      // Create notification for the new pending transaction
      await PendingTransactionService.notifyPendingCreated(pending);
    }

    if (hasNewTransactions) {
      await NativeSmsService.clearPendingSms();
      debugPrint('🟢 Native SMS cleared');
    }
  }

  /// Enhanced duplicate checking that compares:
  /// 1. Raw SMS content (existing check)
  /// 2. Transaction signature (amount + title + date range)
  /// 3. Similar transactions in main transaction box
  bool _isDuplicateTransaction(
    ParsedSmsTransaction parsed,
    String rawSms,
    Box<PendingTransaction> pendingBox,
    Box<TransactionModel> transactionBox,
  ) {
    // Check 1: Exact SMS already exists in pending
    if (pendingBox.values.any((p) => p.rawSms == rawSms)) {
      return true;
    }

    // Check 2: Same transaction signature in pending
    // (same amount, similar title, within 1 hour)
    final now = DateTime.now();

    for (final pending in pendingBox.values) {
      if (_isSimilarTransaction(
        amount1: pending.amount,
        title1: pending.title,
        date1: pending.date,
        amount2: parsed.amount,
        title2: parsed.title,
        date2: parsed.date,
      )) {
        debugPrint('🔍 Similar pending transaction found: ${pending.title}');
        return true;
      }
    }

    // Check 3: Same transaction already confirmed in main transactions
    // (within last 24 hours to avoid false positives)
    final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));

    for (final tx in transactionBox.values) {
      if (tx.date.isAfter(twentyFourHoursAgo) &&
          _isSimilarTransaction(
            amount1: tx.amount,
            title1: tx.title,
            date1: tx.date,
            amount2: parsed.amount,
            title2: parsed.title,
            date2: parsed.date,
          )) {
        debugPrint('🔍 Similar confirmed transaction found: ${tx.title}');
        return true;
      }
    }

    return false;
  }

  /// Check if two transactions are similar enough to be considered duplicates
  bool _isSimilarTransaction({
    required double amount1,
    required String title1,
    required DateTime date1,
    required double amount2,
    required String title2,
    required DateTime date2,
  }) {
    // Amount must be exactly the same
    if (amount1 != amount2) return false;

    // Date must be within 2 hours of each other
    final timeDiff = date1.difference(date2).abs();
    if (timeDiff.inHours > 2) return false;

    // Title similarity check (basic string matching)
    final title1Clean = title1.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final title2Clean = title2.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    // Special case: Allow multiple transactions for common merchants within reasonable time
    if (_isFrequentMerchant(title1Clean) && timeDiff.inMinutes > 15) {
      return false; // Allow multiple purchases from same merchant if >15 min apart
    }

    // If titles are very similar (70% match), consider it duplicate
    final similarity = _calculateStringSimilarity(title1Clean, title2Clean);
    return similarity > 0.7;
  }

  /// Check if merchant commonly has multiple legitimate transactions
  bool _isFrequentMerchant(String title) {
    final frequentMerchants = [
      'coffee',
      'cafe',
      'starbucks',
      'dunkin',
      'uber',
      'ola',
      'taxi',
      'metro',
      'parking',
      'toll',
      'fuel',
      'petrol',
      'grocery',
      'supermarket',
      'convenience',
    ];

    return frequentMerchants.any((merchant) => title.contains(merchant));
  }

  /// Basic string similarity calculation (Jaccard similarity)
  double _calculateStringSimilarity(String str1, String str2) {
    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    final words1 = str1.split(' ').toSet();
    final words2 = str2.split(' ').toSet();

    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;

    return union == 0 ? 0.0 : intersection / union;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          const HomeHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(TSizes.md, 0, TSizes.md, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [RecentTransactionsSection()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> requestSmsPermission() async {
  var status = await Permission.sms.status;
  if (!status.isGranted) {
    await Permission.sms.request();
  }

  // Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
