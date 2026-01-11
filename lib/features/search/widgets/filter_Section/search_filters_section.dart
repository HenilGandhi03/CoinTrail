import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cointrail/features/search/controller/search_filter_controller.dart';
import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/features/search/widgets/filter_Section/CategorySelector/category_selector.dart';
import 'package:cointrail/features/search/widgets/filter_Section/DateSelector/date_selector.dart';
import 'package:cointrail/features/search/widgets/filter_Section/ReportTypeSelector/report_type_selector.dart';
import 'package:cointrail/features/search/widgets/filter_Section/SearchButton/search_button.dart';

class SearchFiltersSection extends StatelessWidget {
  const SearchFiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchFilterController>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(TSizes.lg, 0, TSizes.lg, 0),
          child: Column(
            children: [
              // ───────── CATEGORY ─────────
              CategorySelector(
                selectedCategory: controller.selectedCategory,
                onSelected: controller.setCategory,
              ),
              // const SizedBox(height: TSizes.spaceBtwSections),
              const SizedBox(height: TSizes.sm),

              // ───────── DATE ─────────
              DateSelector(
                focusedMonth: controller.focusedMonth,
                rangeStart: controller.rangeStart,
                rangeEnd: controller.rangeEnd,
                showCalendar: controller.showCalendar,
                onToggle: controller.toggleCalendar,
                onMonthChanged: controller.setFocusedMonth,
                onDaySelected: (date) {
                  if (controller.rangeStart == null ||
                      controller.rangeEnd != null) {
                    controller.setDateRange(date, null);
                  } else {
                    final start = controller.rangeStart!;
                    if (date.isBefore(start)) {
                      controller.setDateRange(date, start);
                    } else {
                      controller.setDateRange(start, date);
                    }
                    controller.closeCalendar();
                  }
                },
              ),
              const SizedBox(height: TSizes.sm),

              // ───────── REPORT TYPE ─────────
              ReportTypeSelector(
                isExpense: controller.isExpense,
                onChanged: controller.setReportType,
              ),
              const SizedBox(height: TSizes.lg),

              // ───────── SEARCH BUTTON ─────────
              SearchButton(
                onPressed: () {
                  controller.closeCalendar();
                  controller.closeCategorySelector();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
