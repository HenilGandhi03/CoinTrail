// import 'package:cointrail/common/header/appHeader.dart';
// import 'package:cointrail/common/header/widgets/income_expense_summart.dart';
// import 'package:cointrail/core_utils/constants/sizes.dart';
// import 'package:cointrail/features/analysis/controller/analysis_controller.dart';
// import 'package:cointrail/features/home/widgets/chart/spending_by_category_section.dart';
// import 'package:cointrail/features/settings/widgets/common/settings_card.dart';
// import 'package:flutter/material.dart';

// class AnalysisPage extends StatefulWidget {
//   const AnalysisPage({super.key});

//   @override
//   State<AnalysisPage> createState() => _AnalysisPageState();
// }

// class _AnalysisPageState extends State<AnalysisPage> {
//   late final AnalysisController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = AnalysisController();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           AppHeader(
//             title: 'Analysis',
//             showBack: true,
//             showNotification: true,
//             extendedHeight: true,

//             bottom_analysis: IncomeExpenseSummary(
//               totalBalance: 7783.00,
//               totalExpense: 1187.40,
//               limit: 20000,
//               progress: 0.3,
//               hintText: '30% of your expenses, looks good.',
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: AnimatedBuilder(
//               animation: controller,
//               builder: (_, __) {
//                 return Padding(
//                   padding: const EdgeInsets.fromLTRB(
//                     TSizes.md,
//                     0,
//                     TSizes.md,
//                     0,
//                   ),
//                   child: Column(
//                     children: [
//                       /// Overview
//                       Row(
//                         children: [
//                           _OverviewCard(
//                             title: 'Income',
//                             amount: controller.totalIncome,
//                             color: Colors.green,
//                           ),
//                           const SizedBox(width: 12),
//                           _OverviewCard(
//                             title: 'Expense',
//                             amount: controller.totalExpense,
//                             color: Colors.red,
//                           ),
//                           const SizedBox(width: 12),
//                           _OverviewCard(
//                             title: 'Balance',
//                             amount: controller.balance,
//                             color: Colors.blue,
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),
//                       SpendingByCategorySection(),

//                       /// Category Breakdown
//                       SettingsCard(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Category Breakdown',
//                               style: Theme.of(context).textTheme.titleMedium
//                                   ?.copyWith(fontWeight: FontWeight.w600),
//                             ),
//                             const SizedBox(height: 12),
//                             ...controller.categoryBreakdown.entries.map(
//                               (e) => _CategoryRow(name: e.key, amount: e.value),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CategoryRow extends StatelessWidget {
//   final String name;
//   final double amount;

//   const _CategoryRow({required this.name, required this.amount});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Expanded(child: Text(name)),
//           Text(
//             '₹${amount.toStringAsFixed(0)}',
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OverviewCard extends StatelessWidget {
//   final String title;
//   final double amount;
//   final Color color;

//   const _OverviewCard({
//     required this.title,
//     required this.amount,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: Theme.of(context).textTheme.labelMedium),
//             const SizedBox(height: 8),
//             Text(
//               '₹${amount.toStringAsFixed(0)}',
//               style: Theme.of(
//                 context,
//               ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/features/analysis/pages/analysis_page.dart

import 'package:cointrail/common/header/appHeader.dart';
import 'package:cointrail/common/header/widgets/income_expense_summart.dart';
import 'package:cointrail/features/analysis/controller/analysis_controller.dart';
import 'package:cointrail/features/analysis/widgets/AnalysisRangeSelector.dart';
import 'package:cointrail/features/analysis/widgets/analysis_date_nav.dart';
import 'package:cointrail/features/analysis/widgets/spending_by_category_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AnalysisRangeType { weekly, monthly, custom }

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnalysisController(),
      child: const AnalysisPageView(),
    );
  }
}

class AnalysisPageView extends StatelessWidget {
  const AnalysisPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AnalysisController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppHeader(
            title: 'Analysis',
            showBack: true,
            showNotification: true,
            extendedHeight: true,

            // 🔵 GREEN AREA
            pinnedWidgets: [
              AnalysisDateNav(
                start: controller.range.start,
                end: controller.range.end,
                onPrev: controller.previous,
                onNext: controller.next,
              ),
            ],

            // ⚪ WHITE AREA
            bottom_analysis: Column(
              children: [
                const SizedBox(height: 6),
                AnalysisRangeSelector(controller: controller),
                // const SizedBox(height: 16),
                IncomeExpenseSummary(
                  totalBalance: controller.balance,
                  totalExpense: controller.totalExpense,
                  limit: controller.monthlyLimit,
                  progress: controller.totalExpense / controller.monthlyLimit,
                  hintText:
                      controller.totalExpense < controller.monthlyLimit * 0.5
                      ? 'Great spending control!'
                      : controller.totalExpense < controller.monthlyLimit * 0.8
                      ? 'Good spending control!'
                      : 'Watch your spending!',
                ),
              ],
            ),
          ),

          // PAGE CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  SpendingByCategorySection(),
                  // category list etc
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
