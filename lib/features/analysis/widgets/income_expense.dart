import 'package:flutter/material.dart';

enum AnalysisType { income, expense }

class IncomeExpensePills extends StatelessWidget {
  final AnalysisType selected;
  final ValueChanged<AnalysisType> onChanged;

  const IncomeExpensePills({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        _Pill(
          label: 'Income',
          isSelected: selected == AnalysisType.income,
          selectedColor: colors.primary,
          onTap: () => onChanged(AnalysisType.income),
        ),
        const SizedBox(width: 12),
        _Pill(
          label: 'Expense',
          isSelected: selected == AnalysisType.expense,
          selectedColor: colors.error,
          onTap: () => onChanged(AnalysisType.expense),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? selectedColor : colors.outline,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
