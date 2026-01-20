import 'package:cointrail/features/inbox/widgets/activity_tab.dart';
import 'package:cointrail/features/inbox/widgets/notification_tab.dart';
import 'package:cointrail/features/inbox/widgets/pending_tab.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inbox'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Activity'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [PendingTab(), ActivityTab(), NotificationsTab()],
        ),
      ),
    );
  }
}
