// // TODO
// import 'package:hive/hive.dart';
// import '../models/pending_transaction_model.dart';
// import '../models/transaction_model.dart';
// import '../models/activity_log_model.dart';
// import '../models/app_notification_model.dart';

// class PendingTransactionService {
//   static Future<void> approve(PendingTransaction pending) async {
//     final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
//     final transactionBox = Hive.box<TransactionModel>('transactions');
//     final activityBox = Hive.box<ActivityLog>('activity_logs');
//     final notificationBox = Hive.box<AppNotification>('notifications');

//     // Prevent double approval
//     if (transactionBox.containsKey(pending.id)) return;

//     final transaction = TransactionModel(
//       id: pending.id,
//       title: pending.title,
//       amount: pending.amount,
//       type: pending.type,
//       paymentMode: pending.paymentMode,
//       date: pending.date,
//       category: 'Uncategorized',
//       note: pending.rawSms,
//     );

//     await transactionBox.put(transaction.id, transaction);

//     await activityBox.put(
//       pending.id,
//       ActivityLog(
//         id: pending.id,
//         message: 'Transaction approved: ${pending.title}',
//         timestamp: DateTime.now(),
//       ),
//     );

//     final notification = notificationBox.get(pending.id);
//     if (notification != null) {
//       await notificationBox.put(
//         pending.id,
//         AppNotification(
//           id: notification.id,
//           title: notification.title,
//           body: notification.body,
//           date: notification.date,
//           isRead: true,
//         ),
//       );
//     }

//     // 🔥 THIS removes it from inbox
//     await pendingBox.delete(pending.id);
//   }

//   static Future<void> removePending(PendingTransaction pending) async {
//     final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
//     await pendingBox.delete(pending.id);

//     // Also mark notification as read if exists
//     final notificationBox = Hive.box<AppNotification>('notifications');
//     final notification = notificationBox.get(pending.id);
//     if (notification != null) {
//       await notificationBox.put(
//         pending.id,
//         AppNotification(
//           id: notification.id,
//           title: notification.title,
//           body: notification.body,
//           date: notification.date,
//           isRead: true,
//         ),
//       );
//     }
//   }
// }

import 'package:cointrail/data/models/activity_log_model.dart';
import 'package:cointrail/data/models/app_notification_model.dart';
import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PendingTransactionService {
  PendingTransactionService._();

  // ─────────────────────────────────────────────────────────────
  // Remove pending transaction after successful save
  // ─────────────────────────────────────────────────────────────
  static Future<void> removePending(PendingTransaction pending) async {
    final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
    final activityBox = Hive.box<ActivityLog>('activity_logs');
    final notificationBox = Hive.box<AppNotification>('notifications');

    // 1️⃣ Remove from pending inbox
    if (pendingBox.containsKey(pending.id)) {
      await pendingBox.delete(pending.id);
    }

    // 2️⃣ Log activity
    await activityBox.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      ActivityLog(
        id: pending.id,
        message: 'Transaction confirmed: ${pending.title}',
        timestamp: DateTime.now(),
      ),
    );

    // 3️⃣ Mark related notification as read (if exists)
    final notification = notificationBox.get(pending.id);
    if (notification != null && !notification.isRead) {
      await notificationBox.put(
        notification.id,
        AppNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          date: notification.date,
          isRead: true,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Remove pending WITHOUT approving (dismiss / ignore)
  // ─────────────────────────────────────────────────────────────
  static Future<void> discardPending(PendingTransaction pending) async {
    final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
    final activityBox = Hive.box<ActivityLog>('activity_logs');

    if (pendingBox.containsKey(pending.id)) {
      await pendingBox.delete(pending.id);
    }

    await activityBox.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      ActivityLog(
        id: pending.id,
        message: 'Pending transaction discarded: ${pending.title}',
        timestamp: DateTime.now(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Create notification when new pending arrives
  // (called from native sync or manual injection)
  // ─────────────────────────────────────────────────────────────
  static Future<void> notifyPendingCreated(PendingTransaction pending) async {
    final notificationBox = Hive.box<AppNotification>('notifications');

    if (notificationBox.containsKey(pending.id)) return;

    await notificationBox.put(
      pending.id,
      AppNotification(
        id: pending.id,
        title: 'Transaction detected',
        body: '₹${pending.amount.toStringAsFixed(0)} · ${pending.title}',
        date: DateTime.now(),
        isRead: false,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Clean up old pending transactions (older than 7 days)
  // This prevents the pending list from growing indefinitely
  // ─────────────────────────────────────────────────────────────
  static Future<void> cleanupOldPendingTransactions() async {
    final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
    final cutoffDate = DateTime.now().subtract(const Duration(days: 7));

    final keysToDelete = <String>[];

    for (final entry in pendingBox.toMap().entries) {
      final pending = entry.value;
      if (pending.date.isBefore(cutoffDate)) {
        keysToDelete.add(entry.key);
      }
    }

    for (final key in keysToDelete) {
      await pendingBox.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      debugPrint(
        '🧹 Cleaned up ${keysToDelete.length} old pending transactions',
      );
    }
  }
}
