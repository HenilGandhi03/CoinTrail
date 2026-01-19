// lib/features/analysis/widgets/analysis_range_selector.dart
import 'package:cointrail/features/analysis/screen/analysis_page.dart';
import 'package:flutter/material.dart';
import '../controller/analysis_controller.dart';

class AnalysisRangeSelector extends StatelessWidget {
  final AnalysisController controller;

  const AnalysisRangeSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<AnalysisRangeType>(
        segments: const [
          ButtonSegment(value: AnalysisRangeType.weekly, label: Text('Weekly')),
          ButtonSegment(
            value: AnalysisRangeType.monthly,
            label: Text('Monthly'),
          ),
          ButtonSegment(value: AnalysisRangeType.custom, label: Text('Custom')),
        ],
        selected: {controller.rangeType},
        onSelectionChanged: (set) async {
          final type = set.first;

          if (type == AnalysisRangeType.custom) {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controller.setCustomRange(picked);
            }
          } else {
            controller.switchRange(type);
          }
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12),
          ),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary;
            }
            return Theme.of(context).colorScheme.onSurface;
          }),
        ),
      ),
    );
  }
}
