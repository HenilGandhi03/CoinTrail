import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:cointrail/features/inbox/screen/add_transaction_from_pending_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PendingTab extends StatelessWidget {
  const PendingTab();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PendingTransaction>('pending_transactions');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (_, Box<PendingTransaction> box, __) {
        if (box.isEmpty) {
          return const Center(child: Text('No pending transactions'));
        }

        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (_, index) {
            final tx = box.getAt(index)!;

            return Dismissible(
              key: ValueKey(tx.id),
              onDismissed: (_) => box.delete(tx.id),
              child: ListTile(
                title: Text(tx.title),
                subtitle: Text('₹${tx.amount.toStringAsFixed(0)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddTransactionFromPendingPage(pending: tx),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
