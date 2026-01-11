import 'package:cointrail/data/hive/boxes.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/features/debug/widgets/transaction_log_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveLogsPage extends StatelessWidget {
  const HiveLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Logs (Transactions)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Hive',
            onPressed: () async {
              await HiveBoxes.transactions().clear();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveBoxes.transactions().listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No transactions in Hive',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final transactions = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final tx = transactions[index];

              return TransactionLogTile(tx: tx);
            },
          );
        },
      ),
    );
  }
}
