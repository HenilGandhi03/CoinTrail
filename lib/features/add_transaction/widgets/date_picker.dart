import 'package:cointrail/features/add_transaction/controller/add_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatelessWidget {
  final AddTransactionController controller;

  const DatePicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<AddTransactionController>(); // 👈 KEY

    // Start of week (Monday)
    final startOfWeek = controller.selectedDate.subtract(
      Duration(days: controller.selectedDate.weekday - 1),
    );

    final weekDays = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// Header (Month + Year + arrows)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => controller.changeWeek(-1),
              ),
              Text(
                DateFormat('MMMM - yyyy').format(controller.selectedDate),
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => controller.changeWeek(1),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Weekday labels
          Row(
            children: weekDays.map((date) {
              return Expanded(
                child: Center(
                  child: Text(
                    DateFormat('EE').format(date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          /// Dates (ONLY THIS WEEK)
          Row(
            children: weekDays.map((date) {
              final isSelected = DateUtils.isSameDay(
                date,
                controller.selectedDate,
              );

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.setDate(date),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
