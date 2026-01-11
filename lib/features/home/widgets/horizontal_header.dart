import 'package:flutter/material.dart';

enum TransactionPeriod { daily, weekly, monthly, all }

class HorizontalHeader extends StatelessWidget {
  const HorizontalHeader({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TransactionPeriod selected;
  final ValueChanged<TransactionPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('HorizontalHeader rebuild → selected: $selected');

    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4), // Add padding around the segments
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Segment(
            label: 'All',
            isSelected: selected == TransactionPeriod.all,
            onTap: () => onChanged(TransactionPeriod.all),
          ),
          _Segment(
            label: 'Daily',
            isSelected: selected == TransactionPeriod.daily,
            onTap: () => onChanged(TransactionPeriod.daily),
          ),
          _Segment(
            label: 'Weekly',
            isSelected: selected == TransactionPeriod.weekly,
            onTap: () => onChanged(TransactionPeriod.weekly),
          ),
          _Segment(
            label: 'Monthly',
            isSelected: selected == TransactionPeriod.monthly,
            onTap: () => onChanged(TransactionPeriod.monthly),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 00),
        // curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
