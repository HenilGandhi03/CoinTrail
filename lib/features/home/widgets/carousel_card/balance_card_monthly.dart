import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/core_utils/constants/text_strings.dart';
import 'package:cointrail/core_utils/theme/AppGradients.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'balance_card_base.dart';

class BalanceCardMonthly extends StatelessWidget {
  const BalanceCardMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final controller = context.watch<HomeController>();
    final summary = controller.monthlySummary;
    final cardGradient = Theme.of(context).extension<AppGradients>()!.card;

    return BalanceCardBase(
      gradient: cardGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _MonthlyHeader(),

          const SizedBox(height: TSizes.xs),

          Flexible(
            child: Text(
              '\₹${summary.totalSpent.toStringAsFixed(0)}',
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
                    'Budget: \₹${summary.budget.toStringAsFixed(0)}',
                    style: TextStyle(color: colors.onPrimary.withOpacity(0.8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: TSizes.xs),
                Flexible(
                  child: Text(
                    'Remaining: \₹${summary.remaining.toStringAsFixed(0)}',
                    style: TextStyle(color: colors.onPrimary.withOpacity(0.8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.xs),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: summary.progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: colors.onPrimary.withOpacity(0.2),
              color: colors.onPrimary,
            ),
          ),

          const SizedBox(height: TSizes.xs),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${(summary.progress * 100).toStringAsFixed(1)}% used',
                  style: TextStyle(color: colors.onPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: TSizes.xs),
              Flexible(
                child: Text(
                  '${summary.daysLeft} days left',
                  style: TextStyle(color: colors.onPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TTexts.homeCard_TotalSpent,
          style: theme.textTheme.titleMedium?.copyWith(color: colors.onPrimary),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.attach_money, color: Colors.white),
        ),
      ],
    );
  }
}
