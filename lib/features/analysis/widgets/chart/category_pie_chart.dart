import 'package:cointrail/data/models/category_spending_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../home/controller/home_controller.dart';
import 'package:provider/provider.dart';

// class CategoryPieChart extends StatelessWidget {
//   const CategoryPieChart({super.key, required bool showCenterLabel, required String centerLabel});

//   @override
//   Widget build(BuildContext context) {
//     final categories = context.watch<HomeController>().categories;

//     return PieChart(
//       PieChartData(
//         sectionsSpace: 2,
//         centerSpaceRadius: 36,
//         sections: categories.map<PieChartSectionData>((category) {
//           return PieChartSectionData(
//             value: category.amount,
//             color: category.color,
//             radius: 28,
//             showTitle: false,
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
class CategoryPieChart extends StatelessWidget {
  final List<CategorySpendingModel> data;
  final bool showCenterLabel;
  final String centerLabel;
  final Color centerColor;

  const CategoryPieChart({
    super.key,
    required this.data,
    required this.showCenterLabel,
    required this.centerLabel,
    required this.centerColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 48,
            sections: data.map((c) {
              return PieChartSectionData(
                value: c.amount,
                color: c.color,
                radius: 22,
                showTitle: false,
              );
            }).toList(),
          ),
        ),

        if (showCenterLabel)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(centerLabel, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                '₹${data.fold<double>(0, (s, e) => s + e.amount).toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: centerColor,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
