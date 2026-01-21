import 'package:cointrail/features/settings/widgets/common/settings_card.dart';
import 'package:cointrail/features/debug/widgets/inbox_debug_helper.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class DebugSection extends StatelessWidget {
//   const DebugSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: const Text('Debug Options'),
//       children: [
//         ListTile(
//           title: const Text('Print Debug Info'),
//           onTap: () {
//             Get.toNamed(TRoutes.hiveDebugLogs);
//             debugPrint('Debug info printed to console.');
//           },
//         ),
//         ListTile(
//           title: const Text('Clear Cache'),
//           onTap: () {
//             // TODO
//             // Add your cache clearing logic here
//             debugPrint('Cache cleared.');
//           },
//         ),
//       ],
//     );
//   }
// }

class DebugSection extends StatelessWidget {
  const DebugSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(
                Icons.build_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Hive Debug Logs',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SecurityTile(
            icon: Icons.developer_board_rounded,
            title: 'Debug Page',
            onTap: () {
              Get.toNamed(TRoutes.hiveDebugLogs);
            },
          ),

          const SizedBox(height: 8),

          _SecurityTile(
            icon: Icons.inbox_rounded,
            title: 'Inbox Debug',
            onTap: () {
              InboxDebugHelper.showDebugDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SecurityTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
