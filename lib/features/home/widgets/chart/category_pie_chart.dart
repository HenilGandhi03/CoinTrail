import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../controller/home_controller.dart';
import 'package:provider/provider.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key, required bool showCenterLabel, required String centerLabel});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<HomeController>().categories;

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 36,
        sections: categories.map<PieChartSectionData>((category) {
          return PieChartSectionData(
            value: category.amount,
            color: category.color,
            radius: 28,
            showTitle: false,
          );
        }).toList(),
      ),
    );
  }
}
