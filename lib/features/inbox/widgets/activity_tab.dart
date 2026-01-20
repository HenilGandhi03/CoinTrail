import 'package:cointrail/data/models/activity_log_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ActivityTab extends StatelessWidget {
  const ActivityTab();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ActivityLog>('activity_logs');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (_, Box<ActivityLog> box, __) {
        if (box.isEmpty) {
          return const Center(child: Text('No activity yet'));
        }

        final items = box.values.toList().reversed.toList();

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            final log = items[index];
            return ListTile(
              title: Text(log.message),
              subtitle: Text(log.timestamp.toString()),
            );
          },
        );
      },
    );
  }
}
