import 'package:cointrail/app/app.dart';
import 'package:cointrail/data/hive/hive_service.dart';
import 'package:cointrail/data/sources/local/category_hive_source.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await HiveService.init(); 
  
  // Seed default categories and debug
  final categorySource = CategoryHiveSource();
  await categorySource.seedDefaultsIfEmpty();
  
  // Debug categories after initialization
  HiveService.debugHiveStatus();
  HiveService.debugCategories();

  runApp(const App());
}
