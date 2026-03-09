import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cointrail/core_utils/constants/text_strings.dart';
import 'package:cointrail/core_utils/theme/AppGradients.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:provider/provider.dart';
import 'balance_card_base.dart';

class BalanceCardIncome extends StatelessWidget {
  const BalanceCardIncome({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cardGradient = Theme.of(context).extension<AppGradients>()!.card;

    final income = context.watch<HomeController>().incomeSummary;

    return BalanceCardBase(
      gradient: cardGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _IncomeHeader(),

          const SizedBox(height: TSizes.xs),

          Flexible(
            child: Text(
              '\₹${income.totalIncome.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: TSizes.xs),

          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Source: ${income.source}',
                    style: TextStyle(color: colors.onPrimary.withOpacity(0.8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: TSizes.xs),
                Flexible(
                  child: Text(
                    'Next: ${income.nextDate}',
                    style: TextStyle(color: colors.onPrimary.withOpacity(0.8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.xs),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.trending_up, color: Colors.white, size: 20),
                Flexible(
                  child: Text(
                    '+${income.growthPercent.toStringAsFixed(1)}% this month',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeHeader extends StatelessWidget {
  const _IncomeHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TTexts.homeCard_Income,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colors.onPrimary),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.account_balance_wallet, color: Colors.white),
        ),
      ],
    );
  }
}
