// lib/features/inbox/controller/inbox_badge_controller.dart

import 'package:flutter/material.dart';
import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:cointrail/data/models/app_notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InboxBadgeController extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  late final Box<PendingTransaction> _pendingBox;
  late final Box<AppNotification> _notificationBox;

  InboxBadgeController() {
    _pendingBox = Hive.box<PendingTransaction>('pending_transactions');
    _notificationBox = Hive.box<AppNotification>('notifications');

    _recalculate();

    _pendingBox.listenable().addListener(_recalculate);
    _notificationBox.listenable().addListener(_recalculate);
  }

  void _recalculate() {
    final pendingCount = _pendingBox.length;

    final unreadNotifications = _notificationBox.values
        .where((n) => !n.isRead)
        .length;

    final newCount = pendingCount + unreadNotifications;

    if (newCount != _count) {
      _count = newCount;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pendingBox.listenable().removeListener(_recalculate);
    _notificationBox.listenable().removeListener(_recalculate);
    super.dispose();
  }
}
