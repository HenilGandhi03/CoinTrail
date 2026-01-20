import 'package:flutter/material.dart';

class IncomeExpenseSummary extends StatelessWidget {
  const IncomeExpenseSummary({
    super.key,
    required this.totalBalance,
    required this.totalExpense,
    required this.limit,
    required this.progress,
    this.hintText,
  });

  final double totalBalance;
  final double totalExpense;
  final double limit;

  /// value between 0.0 – 1.0
  final double progress;

  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ───── TOP ROW ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              _StatItem(
                label: 'Total Balance',
                value: totalBalance,
                valueColor: colors.primary,
              ),
              _StatItem(
                label: 'Total Expense',
                value: totalExpense,
                valueColor: Colors.blueAccent,
                isNegative: true,
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ───── PROGRESS BAR ─────
          Container(
            padding: const EdgeInsets.all(1), // border thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.outline, // 👈 border color
                width: .5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: colors.surface,
                valueColor: AlwaysStoppedAnimation(colors.primary),
              ),
            ),
          ),

          const SizedBox(height: 2),

          /// ───── LIMIT TEXT ─────
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '\₹${limit.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          if (hintText != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.check_circle, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Text(hintText!, style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isNegative = false,
  });

  final String label;
  final double value;
  final Color valueColor;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 0.0),
          child: Row(
            children: [
              const Icon(Icons.check_box, size: 16),
              const SizedBox(width: 6),
              Text(label, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${isNegative ? '-' : ''}\₹${value.toStringAsFixed(2)}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
