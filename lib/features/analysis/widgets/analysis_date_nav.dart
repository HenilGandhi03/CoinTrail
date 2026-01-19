// lib/features/analysis/widgets/analysis_date_nav.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysisDateNav extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const AnalysisDateNav({
    super.key,
    required this.start,
    required this.end,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ⬅ PREVIOUS
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: onPrev,
          ),

          // 📅 DATE RANGE
          Expanded(
            child: Center(
              child: Text(
                '${DateFormat('dd MMM').format(start)} – ${DateFormat('dd MMM').format(end)}',
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ➡ NEXT
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
