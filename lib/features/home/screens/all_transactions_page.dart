import 'package:cointrail/common/header/appHeader.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:cointrail/features/home/widgets/day_transaction_header.dart';
import 'package:cointrail/features/home/widgets/horizontal_header.dart';
import 'package:cointrail/features/home/widgets/month_selector.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transaction_tile.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// lib/features/home/pages/all_transactions_page.dart

class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  Map<DateTime, List<TransactionModel>> groupByDay(
    List<TransactionModel> transactions,
  ) {
    final Map<DateTime, List<TransactionModel>> grouped = {};

    for (final tx in transactions) {
      final key = DateTime(tx.date.year, tx.date.month, tx.date.day);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(tx);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (final k in sortedKeys) k: grouped[k]!};
  }

  List<TransactionModel> filter(
    List<TransactionModel> all,
    TransactionPeriod period,
    DateTime month,
  ) {
    final now = DateTime.now();

    return all.where((tx) {
      final d = tx.date;

      if (d.year != month.year || d.month != month.month) return false;

      switch (period) {
        case TransactionPeriod.all:
          return true;
        case TransactionPeriod.daily:
          return d.year == now.year && d.month == now.month && d.day == now.day;
        case TransactionPeriod.weekly:
          final start = now.subtract(Duration(days: now.weekday - 1));
          return d.isAfter(start);
        case TransactionPeriod.monthly:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    final filtered = filter(
      controller.getAllTransactions(),
      controller.selectedPeriod,
      controller.selectedMonth,
    );

    final grouped = groupByDay(filtered);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppHeader(
            title: 'All Transactions',
            showBack: true,
            bottom_alltx: MonthSelector(
              month: controller.selectedMonth,
              onPrev: controller.previousMonth,
              onNext: controller.nextMonth,
            ),
          ),

          SliverToBoxAdapter(
            child: HorizontalHeader(
              selected: controller.selectedPeriod,
              onChanged: controller.updatePeriod,
            ),
          ),

          grouped.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('No transactions')),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final date = grouped.keys.elementAt(index);
                    final txs = grouped[date]!;

                    return Column(
                      children: [
                        DayTransactionHeader(date: date, transactions: txs),
                        ...txs.map(
                          (tx) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: RecentTransactionTile(
                              transaction: tx,
                              showDate: false,
                              onTap: () {
                                Get.toNamed(
                                  TRoutes.editTransaction,
                                  arguments: tx,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }, childCount: grouped.length),
                ),
        ],
      ),
    );
  }
}
