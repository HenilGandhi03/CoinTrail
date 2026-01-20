import 'package:cointrail/data/models/app_notification_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AppNotification>('notifications');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (_, Box<AppNotification> box, __) {
        if (box.isEmpty) {
          return const Center(child: Text('No notifications'));
        }

        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (_, index) {
            final n = box.getAt(index)!;

            return ListTile(
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: n.isRead ? null : const Icon(Icons.circle, size: 8),
              onTap: () {
                box.put(
                  n.id,
                  AppNotification(
                    id: n.id,
                    title: n.title,
                    body: n.body,
                    date: n.date,
                    isRead: true,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
