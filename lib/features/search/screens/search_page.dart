import 'package:cointrail/features/search/widgets/filter_Section/search_filters_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cointrail/features/search/controller/search_filter_controller.dart';
import 'package:cointrail/features/search/widgets/search_header.dart';
import 'package:cointrail/features/search/widgets/search_results_section.dart';
import 'package:cointrail/features/settings/controller/settings_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchFilterController()),
        ChangeNotifierProvider.value(value: SettingsController.instance),
      ],
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchFilterController>(
      builder: (context, controller, child) {
        // Calculate dynamic spacing based on calendar and category state
        final baseSpacing = 270.0;
        final calendarHeight = controller.showCalendar ? 310.0 : 0.0;
        final categoryHeight = controller.showCategorySelector ? 120.0 : 0.0;
        final totalSpacing = baseSpacing + calendarHeight + categoryHeight;

        return CustomScrollView(
          slivers: [
            // HEADER (as a sliver)
            const SearchHeader(),

            // Content as a sliver
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // Main content column
                  Column(
                    children: [SearchFiltersSection(), SearchResultsSection()],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
