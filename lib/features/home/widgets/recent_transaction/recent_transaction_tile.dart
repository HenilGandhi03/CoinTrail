import 'package:cointrail/core_utils/constants/colors.dart';
import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/category_chip.dart';
import 'package:flutter/material.dart';

class RecentTransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const RecentTransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final colors = Theme.of(context).colorScheme;

    final amountColor = isIncome ? TColors.income : TColors.expense;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),

      child: Row(
        children: [
          // ----------------------------------
          // Category Icon (small & clean)
          // ----------------------------------
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Icon(
              _iconForCategory(transaction.category),
              size: 26,
              color: amountColor,
            ),
          ),

          const SizedBox(width: TSizes.md),

          // ----------------------------------
          // Title + meta (category + date)
          // ----------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    CategoryChip(label: transaction.category),
                    const SizedBox(width: 8),
                    Text(
                      transaction.formattedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ----------------------------------
          // Amount
          // ----------------------------------
          Text(
            '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'salary':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
