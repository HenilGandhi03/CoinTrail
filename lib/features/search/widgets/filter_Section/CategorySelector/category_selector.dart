import 'package:cointrail/features/search/widgets/helper_widgets/filter_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/features/search/controller/search_filter_controller.dart';
import 'package:cointrail/features/settings/controller/settings_controller.dart';

class CategorySelector extends StatelessWidget {
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?> onSelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Consumer2<SearchFilterController, SettingsController>(
      builder: (context, filterController, settingsController, _) {
        // Filter categories based on income/expense selection
        final allCategories = settingsController.customCategories;
        final filteredCategories = allCategories
            .where(
              (category) => category.isIncome != filterController.isExpense,
            )
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilterLabel('Category'),
            const SizedBox(height: 8),

            /// Selected pill
            GestureDetector(
              onTap: filterController.toggleCategorySelector,
              child: FilterPill(
                text:
                    selectedCategory?.name ??
                    (filterController.isExpense
                        ? 'All expense categories'
                        : 'All income categories'),
                icon: Icons.keyboard_arrow_down_rounded,
              ),
            ),

            /// Category list
            if (filterController.showCategorySelector)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // "All categories" option
                    GestureDetector(
                      onTap: () {
                        onSelected(null);
                        filterController.closeCategorySelector();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedCategory == null
                              ? colors.primary.withValues(alpha: 0.2)
                              : colors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.apps_rounded,
                              size: 16,
                              color: selectedCategory == null
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              filterController.isExpense
                                  ? 'All expense categories'
                                  : 'All income categories',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Filtered categories (income or expense based on selection)
                    ...filteredCategories.map((cat) {
                      final selected = selectedCategory?.id == cat.id;

                      return GestureDetector(
                        onTap: () {
                          onSelected(cat);
                          filterController.closeCategorySelector();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? cat.color.withValues(alpha: 0.2)
                                : colors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(cat.icon, size: 16, color: cat.color),
                              const SizedBox(width: 6),
                              Text(cat.name),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
