import 'package:cointrail/data/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionLogTile extends StatelessWidget {
  final TransactionModel tx;

  const TransactionLogTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == TransactionType.income;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── HEADER ───
          Row(
            children: [
              Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green : Colors.red,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tx.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}₹${tx.amount}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ─── META ───
          Text('Category: ${tx.category}'),
          Text('Payment: ${tx.paymentMode.name}'),
          Text('Date: ${tx.formattedDate}'),

          if (tx.note != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Note: ${tx.note}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),

          const SizedBox(height: 6),

          // ─── ID ───
          Text(
            'Hive ID: ${tx.id}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
