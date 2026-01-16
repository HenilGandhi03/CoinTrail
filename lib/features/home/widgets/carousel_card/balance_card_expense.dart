import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cointrail/core_utils/constants/text_strings.dart';
import 'package:cointrail/core_utils/theme/AppGradients.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:provider/provider.dart';
import 'balance_card_base.dart';

class BalanceCardExpense extends StatelessWidget {
  const BalanceCardExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cardGradient = Theme.of(context).extension<AppGradients>()!.card;

    final controller = context.watch<HomeController>();
    final expense = controller.expenseSummary;

    return BalanceCardBase(
      gradient: cardGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ExpenseHeader(),

          Text(
            '\₹${expense.totalExpense.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories: ${expense.categories}',
                style: TextStyle(color: colors.onPrimary.withOpacity(0.8)),
              ),
              Text(
                'Today: \₹${expense.today.toStringAsFixed(0)}',
                style: TextStyle(color: colors.onPrimary.withOpacity(0.8)),
              ),
            ],
          ),

          const SizedBox(height: TSizes.sm),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: expense.progress,
              minHeight: 8,
              backgroundColor: colors.onPrimary.withOpacity(0.2),
              color: colors.onPrimary,
            ),
          ),

          const SizedBox(height: TSizes.sm),

          Text(
            '${(expense.progress * 100).toStringAsFixed(1)}% of budget used',
            style: TextStyle(color: colors.onPrimary),
          ),
        ],
      ),
    );
  }
}

class _ExpenseHeader extends StatelessWidget {
  const _ExpenseHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          TTexts.homeCard_Expense,
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
          child: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
      ],
    );
  }
}
