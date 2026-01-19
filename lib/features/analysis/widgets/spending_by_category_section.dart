import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:cointrail/features/home/widgets/chart/category_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TransactionType { income, expense }

class SpendingByCategorySection extends StatefulWidget {
  const SpendingByCategorySection({super.key});

  @override
  State<SpendingByCategorySection> createState() =>
      _SpendingByCategorySectionState();
}

class _SpendingByCategorySectionState extends State<SpendingByCategorySection> {
  TransactionType selectedType = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final categories = controller.categories;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TSizes.lg),
      // padding: const EdgeInsets.all(TSizes.lg),
      // decoration: BoxDecoration(
      //   color: colors.surface,
      //   borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      //   border: Border.all(color: colors.outlineVariant),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────── HEADER ─────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedType == TransactionType.income ? 'Income' : 'Expense'} Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),

          const SizedBox(height: TSizes.lg),

          // ───────── TOGGLE PILLS ─────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(TSizes.sm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TogglePill(
                    label: 'Income',
                    icon: Icons.trending_up,
                    isSelected: selectedType == TransactionType.income,
                    onTap: () =>
                        setState(() => selectedType = TransactionType.income),
                  ),
                ),
                Expanded(
                  child: _TogglePill(
                    label: 'Expense',
                    icon: Icons.trending_down,
                    isSelected: selectedType == TransactionType.expense,
                    onTap: () =>
                        setState(() => selectedType = TransactionType.expense),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.lg),

          // ───────── PIE + LEGEND ─────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donut Chart
              SizedBox(
                width: 160,
                height: 160,
                child: CategoryPieChart(
                  showCenterLabel: true,
                  centerLabel: selectedType == TransactionType.income
                      ? 'Income'
                      : 'Expenses',
                ),
              ),

              const SizedBox(width: TSizes.lg),

              // Legend
              Expanded(
                child: Column(
                  children: categories.map<Widget>((c) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: c.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              c.name,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.lg),

          Divider(color: colors.outlineVariant),

          // ───────── CATEGORY BREAKDOWN ─────────
          Column(
            children: categories.map<Widget>((c) {
              return _CategoryProgressRow(
                name: c.name,
                amount: c.amount,
                percent: c.percentage,
                color: c.color,
                isIncome: selectedType == TransactionType.income,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TogglePill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.xs),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgressRow extends StatelessWidget {
  final String name;
  final double amount;
  final int percent;
  final Color color;
  final bool isIncome;

  const _CategoryProgressRow({
    required this.name,
    required this.amount,
    required this.percent,
    required this.color,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.category, color: color, size: 20),
          ),

          const SizedBox(width: 12),

          // Name + bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 6,
                    backgroundColor: colors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Amount + %
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}₹${amount.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isIncome ? colors.primary : colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$percent%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
