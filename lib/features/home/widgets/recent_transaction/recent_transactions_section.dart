import 'package:cointrail/common/widgets/section_header.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transaction_tile.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final transactions = controller.recentTransactions;

    if (transactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SectionHeader(
          title: 'Recent Transactions',
          action: TextButton(
            onPressed: () {
              Get.toNamed(TRoutes.allTransaction);
              // Navigate to full transaction list later
            },
            child: const Text('View all'),
          ),
        ),

        const SizedBox(height: 8),

        Column(
          children: transactions
              .take(5) // 👈 last 5 only
              .map<Widget>((tx) => RecentTransactionTile(transaction: tx))
              .toList(),
        ),
      ],
    );
  }
}
