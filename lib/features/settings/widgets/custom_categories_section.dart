import 'package:cointrail/data/models/category_model.dart';
import 'package:cointrail/features/settings/controller/settings_controller.dart';
import 'package:cointrail/features/settings/widgets/common/add_category_sheet.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:cointrail/features/settings/widgets/common/settings_card.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomCategoriesSection extends StatelessWidget {
  final SettingsController controller;

  const CustomCategoriesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  Icon(
                    Icons.sell_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Custom Categories',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final category =
                          await showModalBottomSheet<CategoryModel>(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const AddCategorySheet(),
                          );

                      if (category != null) {
                        controller.addCategory(category);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ...controller.customCategories.map(
                (category) => _CategoryTile(
                  category: category,
                  onEdit: () {
                    // navigate to edit page
                  },
                  onDelete: () {
                    controller.deleteCategory(category.id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTile({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: category.color,
            child: Icon(category.icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '— transactions', // hook later
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
