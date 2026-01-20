import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  final String title;
  final double amount;
  final int percent;

  const CategoryRow({
    super.key,
    required this.title,
    required this.amount,
    required this.percent,
    required this.indicatorColor,
  });

  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color dot
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: TSizes.sm),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Percentage
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${percent.toStringAsFixed(0)}%',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Amount on its own line
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withOpacity(0.7),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 4)),
            ],
          ),
        ),
      ],
    );
  }
}
