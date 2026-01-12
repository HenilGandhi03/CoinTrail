import 'package:flutter/material.dart';
import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/features/add_transaction/controller/add_transaction_controller.dart';
import 'package:provider/provider.dart';
import 'category_tile.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategoryId,
    required this.onSelected,
    this.isIncome = false,
  });

  final String? selectedCategoryId;
  final ValueChanged<CategoryModel> onSelected;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddTransactionController>();
    final categories = controller.categories;

    // Debug logging
    print(
      'CategorySelector: isIncome=$isIncome, categories count=${categories.length}',
    );
    for (var category in categories) {
      print('  - ${category.name} (${category.id})');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.6,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryTile(
              category: category,
              isSelected: category.id == selectedCategoryId,
              onTap: () => onSelected(category),
            );
          },
        ),
      ],
    );
  }
}
