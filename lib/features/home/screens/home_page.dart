import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/features/home/widgets/header/home_header.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transactions_section.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          /// ───────────────── HEADER (SLIVER) ─────────────────
          const HomeHeader(),

          /// ───────────────── CONTENT CARD ─────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              TSizes.md,
              0, // compensate for overlap
              TSizes.md,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(TSizes.md, 0, TSizes.md, 0),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [RecentTransactionsSection()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
