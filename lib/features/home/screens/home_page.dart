import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/features/home/widgets/header/home_header.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transactions_section.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          /// ───────────────── HEADER (SLIVER) ─────────────────
          const HomeHeader(),

          /// ───────────────── CONTENT CARD ─────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              TSizes.md,
              0, // compensate for overlap
              TSizes.md,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(TSizes.md, 0, TSizes.md, 0),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [RecentTransactionsSection()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





// import 'package:cointrail/core_utils/constants/sizes.dart';
// import 'package:cointrail/features/home/widgets/header/home_header.dart';
// import 'package:cointrail/features/home/widgets/recent_transaction/recent_transactions_section.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       backgroundColor: colors.surface,
//       body: CustomScrollView(
//         slivers: [
//           /// ───────────────── HEADER (SLIVER) ─────────────────
//           const HomeHeader(),

//           /// ───────────────── CONTENT CARD ─────────────────
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(
//               TSizes.md,
//               0,
//               TSizes.md,
//               0,
//             ),
//             sliver: SliverToBoxAdapter(
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(TSizes.md, 0, TSizes.md, 0),
//                 decoration: BoxDecoration(
//                   color: colors.surfaceContainerHigh,
//                   borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: TSizes.md),

//                     ElevatedButton(
//                       onPressed: () {
//                         const sms =
//                             'Rs. 450 spent on Swiggy via UPI on 18-01-2026';

//                         final parsed = SmsTransactionParser.parse(sms);
//                         debugPrint(parsed?.title);
//                         debugPrint(parsed?.amount.toString());
//                         debugPrint(parsed?.paymentMode.toString());
//                         debugPrint(parsed?.type.toString());
//                       },
//                       child: const Text('Test SMS Parser'),
//                     ),

//                     const SizedBox(height: TSizes.lg),

//                     const RecentTransactionsSection(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
