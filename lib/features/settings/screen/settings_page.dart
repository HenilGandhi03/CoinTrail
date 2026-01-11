import 'package:cointrail/common/header/appHeader.dart' show AppHeader;
import 'package:cointrail/common/header/widgets/profile_avatar.dart';
import 'package:cointrail/features/settings/controller/settings_controller.dart';
import 'package:cointrail/features/settings/widgets/custom_categories_section.dart';
import 'package:cointrail/features/settings/widgets/debug_section.dart';
import 'package:cointrail/features/settings/widgets/export_data_section.dart';
import 'package:cointrail/features/settings/widgets/preferences_section.dart';
import 'package:cointrail/features/settings/widgets/profile_section.dart';
import 'package:cointrail/features/settings/widgets/security_privacy_section.dart';
import 'package:cointrail/features/settings/widgets/settings_menu_section.dart';
import 'package:cointrail/features/settings/widgets/sync_backup_section.dart';
import 'package:flutter/material.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   late final SettingsController settingsController;

//   @override
//   void initState() {
//     super.initState();
//     settingsController = SettingsController();
//   }

//   @override
//   void dispose() {
//     settingsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           AppHeader(
//             title: 'Settings',
//             showBack: true,
//             showNotification: true,
//             centerWidget: ProfileAvatar(
//               imageUrl: settingsController.imageUrl,
//               name: settingsController.fullName,
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               children: [
//                 ProfileSection(controller: settingsController),
//                 ExportDataSection(controller: settingsController),
//                 SyncBackupSection(controller: settingsController),
//                 CustomCategoriesSection(controller: settingsController),
//                 PreferencesSection(controller: settingsController),
//                 SecurityPrivacySection(controller: settingsController),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController settingsController;

  @override
  void initState() {
    super.initState();
    settingsController = SettingsController();
  }

  @override
  void dispose() {
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// ───────── HEADER (PINNED) ─────────
          AppHeader(
            title: 'Settings',
            showBack: true,
            showNotification: true,
            centerWidget: ProfileAvatar(
              imageUrl: settingsController.imageUrl,
              name: settingsController.fullName,
            ),
          ),

          /// ───────── SETTINGS CONTENT ─────────
          SliverList(
            delegate: SliverChildListDelegate([
              ProfileSection(controller: settingsController),
              ExportDataSection(controller: settingsController),
              SyncBackupSection(controller: settingsController),
              CustomCategoriesSection(controller: settingsController),
              PreferencesSection(controller: settingsController),
              DebugSection(),
              SecurityPrivacySection(controller: settingsController),
            ]),
          ),
        ],
      ),
    );
  }
}
