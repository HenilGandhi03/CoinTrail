import 'package:cointrail/common/header/appHeader.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:cointrail/features/home/widgets/horizontal_header.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  List<TransactionModel> filterTransactions(
    List<TransactionModel> all,
    TransactionPeriod period,
  ) {
    final now = DateTime.now();

    switch (period) {
      case TransactionPeriod.all:
        return all;

      case TransactionPeriod.daily:
        return all.where((tx) {
          final d = tx.date;
          return d.year == now.year && d.month == now.month && d.day == now.day;
        }).toList();

      case TransactionPeriod.weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return all.where((tx) => tx.date.isAfter(startOfWeek)).toList();

      case TransactionPeriod.monthly:
        return all.where((tx) {
          final d = tx.date;
          return d.year == now.year && d.month == now.month;
        }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    final transactions = filterTransactions(
      controller.recentTransactions,
      controller.selectedPeriod,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// ───────── HEADER ─────────
          AppHeader(
            title: 'All Transactions',
            showBack: true,
            showNotification: true,
            bottom_alltx: Consumer<HomeController>(
              builder: (context, controller, _) {
                return HorizontalHeader(
                  selected: controller.selectedPeriod,
                  onChanged: controller.updatePeriod,
                );
              },
            ),
          ),

          /// ───────── CONTENT ─────────
          transactions.isEmpty
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              : SliverList.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.fromLTRB(16, 8, 16, 0)
                          : index == transactions.length - 1
                          ? const EdgeInsets.fromLTRB(16, 0, 16, 8)
                          : const EdgeInsets.symmetric(horizontal: 16),
                      child: RecentTransactionTile(transaction: tx),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).dividerColor,
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Your transactions will appear here',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
