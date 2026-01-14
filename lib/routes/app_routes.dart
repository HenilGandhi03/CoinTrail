import 'package:cointrail/features/authentication/screens/login/login_page.dart';
import 'package:cointrail/features/authentication/screens/register/register_page.dart';
import 'package:cointrail/features/authentication/screens/splash/splash_onboarding_screen.dart';
import 'package:cointrail/features/debug/pages/hive_logs_page.dart';
import 'package:cointrail/features/edit_transaction/pages/edit_transaction_page.dart';
import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:cointrail/features/home/screens/all_transactions_page.dart';
import 'package:cointrail/features/root/root_page.dart';
// import 'package:cointrail/fesatures/settings/widgets/common/add_category_sheet.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: TRoutes.splashOnboardingScreen,
      page: () => const SplashOnboardingScreen(),
    ),

    GetPage(name: TRoutes.login, page: () => const LoginPage()),

    GetPage(name: TRoutes.register, page: () => const RegisterPage()),

    GetPage(name: TRoutes.hiveDebugLogs, page: () => const HiveLogsPage()),
    GetPage(
      name: TRoutes.editTransaction,
      page: () => const EditTransactionPage(),
    ),
    GetPage(
      name: TRoutes.allTransaction,
      page: () => ChangeNotifierProvider(
        create: (_) => HomeController(),
        child: const AllTransactionsPage(),
      ),
    ),

    // 👇 SINGLE APP SHELL
    GetPage(
      name: TRoutes.root,
      page: () => ChangeNotifierProvider(
        create: (_) => HomeController(),
        child: const RootPage(),
      ),
    ),
  ];
}
