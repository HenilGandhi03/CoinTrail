import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/data/models/category_spending_model.dart';
import 'package:cointrail/features/analysis/controller/analysis_controller.dart';
import 'package:cointrail/features/analysis/widgets/chart/category_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendingByCategorySection extends StatelessWidget {
  const SpendingByCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AnalysisController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔴 EXPENSE SECTION
          _CategoryBlock(
            title: 'Expense Categories',
            emptyText: 'No expenses in this period',
            isIncome: false,
            categories: controller.expenseCategories,
            centerLabel: 'Expenses',
          ),

          const SizedBox(height: TSizes.xxl),

          /// 🟢 INCOME SECTION
          _CategoryBlock(
            title: 'Income Categories',
            emptyText: 'No income in this period',
            isIncome: true,
            categories: controller.incomeCategories,
            centerLabel: 'Income',
          ),
        ],
      ),
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  final String title;
  final String emptyText;
  final bool isIncome;
  final String centerLabel;
  final List<CategorySpendingModel> categories;

  const _CategoryBlock({
    required this.title,
    required this.emptyText,
    required this.isIncome,
    required this.centerLabel,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// SECTION TITLE
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: TSizes.lg),

        if (categories.isEmpty)
          _EmptyState(
            icon: isIncome ? Icons.trending_up : Icons.trending_down,
            text: emptyText,
          )
        else ...[
          /// PIE + LEGEND
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CategoryPieChart(
                  data: categories,
                  showCenterLabel: true,
                  centerLabel: centerLabel,
                  centerColor: isIncome
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),

              const SizedBox(width: TSizes.lg),

              Expanded(
                child: Column(
                  children: categories.map((c) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: c.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(c.name)),
                          Text('${c.percentage}%'),
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

          /// CATEGORY BREAKDOWN
          ...categories.map((c) {
            return _CategoryProgressRow(
              name: c.name,
              amount: c.amount,
              percent: c.percentage,
              color: c.color,
              isIncome: isIncome,
            );
          }),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: colors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
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
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 6,
                  backgroundColor: colors.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}₹${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: isIncome ? colors.primary : colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('$percent%', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
