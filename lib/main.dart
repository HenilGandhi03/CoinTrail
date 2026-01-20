import 'package:cointrail/app/app.dart';
import 'package:cointrail/data/hive/hive_service.dart';
import 'package:cointrail/data/services/data_seeder.dart';
import 'package:cointrail/data/sources/local/category_hive_source.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init();
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Seed default categories and debug
  final categorySource = CategoryHiveSource();
  await categorySource.seedSystemCategories();

  // Seed sample transaction data
  // await DataSeeder.seedSampleData();

  // Debug categories after initialization
  HiveService.debugHiveStatus();
  HiveService.debugCategories();

  runApp(const App());
}
