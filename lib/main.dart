import 'package:cointrail/app/app.dart';
import 'package:cointrail/data/hive/hive_service.dart';
import 'package:cointrail/data/sources/local/category_hive_source.dart';
import 'package:cointrail/features/inbox/controller/inbox_badge_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init();
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Seed default categories and debug
  final categorySource = CategoryHiveSource();
  await categorySource.seedSystemCategories();

  // Debug categories after initialization
  HiveService.debugHiveStatus();
  HiveService.debugCategories();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InboxBadgeController()),
      ],
      child: const App(),
    ),
  );
}
