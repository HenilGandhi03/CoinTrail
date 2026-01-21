import 'package:cointrail/data/models/app_notification_model.dart';
import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class InboxDebugHelper {
  static void showDebugDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: InboxDebugDialog()),
    );
  }
}

class InboxDebugDialog extends StatefulWidget {
  @override
  State<InboxDebugDialog> createState() => _InboxDebugDialogState();
}

class _InboxDebugDialogState extends State<InboxDebugDialog> {
  @override
  Widget build(BuildContext context) {
    final pendingBox = Hive.box<PendingTransaction>('pending_transactions');
    final notificationBox = Hive.box<AppNotification>('notifications');
    final unreadCount = notificationBox.values.where((n) => !n.isRead).length;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Inbox Debug Info',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),

          // Summary
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inbox Badge Count Breakdown:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('• Pending Transactions: ${pendingBox.length}'),
                  Text('• Unread Notifications: $unreadCount'),
                  Text(
                    '• Total Badge Count: ${pendingBox.length + unreadCount}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pending Transactions
          Text(
            'Pending Transactions (${pendingBox.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: pendingBox.isEmpty
                ? const Text('No pending transactions')
                : ListView.builder(
                    itemCount: pendingBox.length,
                    itemBuilder: (context, index) {
                      final tx = pendingBox.getAt(index)!;
                      return ListTile(
                        title: Text(tx.title),
                        subtitle: Text(
                          '₹${tx.amount.toStringAsFixed(0)} • ${tx.date}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            pendingBox.deleteAt(index);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),

          const Divider(),

          // Notifications
          Text(
            'Notifications (${notificationBox.length}) - Unread: $unreadCount',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: notificationBox.isEmpty
                ? const Text('No notifications')
                : ListView.builder(
                    itemCount: notificationBox.length,
                    itemBuilder: (context, index) {
                      final notification = notificationBox.getAt(index)!;
                      return ListTile(
                        leading: Icon(
                          notification.isRead
                              ? Icons.mark_email_read
                              : Icons.mark_email_unread,
                          color: notification.isRead
                              ? Colors.grey
                              : Colors.blue,
                          size: 20,
                        ),
                        title: Text(notification.title),
                        subtitle: Text(notification.body),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            notificationBox.deleteAt(index);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),

          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Mark all notifications as read
                    for (int i = 0; i < notificationBox.length; i++) {
                      final notification = notificationBox.getAt(i)!;
                      if (!notification.isRead) {
                        notificationBox.putAt(
                          i,
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
                    setState(() {});
                  },
                  child: const Text('Mark All Read'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    pendingBox.clear();
                    notificationBox.clear();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear All'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
