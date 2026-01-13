import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cointrail/features/search/controller/search_filter_controller.dart';
import 'package:cointrail/features/home/widgets/recent_transaction/recent_transaction_tile.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SearchFilterController>();

    if (controller.results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(5),
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.results.length,
      primary: false,
      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
      itemBuilder: (_, i) {
        return RecentTransactionTile(transaction: controller.results[i]);
      },
    );
  }
}
