import 'package:cointrail/features/authentication/widgets/auth_buttons.dart';
import 'package:cointrail/features/authentication/widgets/welcome_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cointrail/core_utils/constants/text_strings.dart';
import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/features/authentication/controller/splash_navigation_controller.dart';
import 'package:cointrail/features/authentication/screens/splash/splash_circle.dart';
import 'package:cointrail/features/authentication/screens/splash/splash_controller.dart';

class SplashOnboardingScreen extends StatefulWidget {
  const SplashOnboardingScreen({super.key});

  @override
  State<SplashOnboardingScreen> createState() => _SplashOnboardingScreenState();
}
// final bool isLoggedIn = navController.isLoggedIn;

class _SplashOnboardingScreenState extends State<SplashOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final SplashController splash;

  @override
  void initState() {
    super.initState();

    /// Start splash animation
    splash = SplashController(this)..start();

    /// Register navigation controller (will be cleaned up on logout)
    if (!Get.isRegistered<SplashNavigationController>()) {
      Get.put(SplashNavigationController());
    }
  }

  @override
  void dispose() {
    splash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: splash.controller,
      builder: (context, _) {
        final bool isFloodFill =
            splash.circleRadius.value >= TTexts.expandedRadius;
        final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

        return Scaffold(
          backgroundColor: colors.secondary,
          body: Stack(
            children: [
              /// Animated splash shape
              SplashCircle(
                positionFromTop: splash.circlePosition.value,
                radius: splash.circleRadius.value,
                bottomContraction: splash.bottomContraction.value,
              ),

              /// App name
              Center(
                child: Opacity(
                  opacity: splash.contentOpacity.value,
                  child: Text(
                    TTexts.appName,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: isFloodFill ? colors.secondary : colors.primary,
                    ),
                  ),
                ),
              ),

              /// CTA buttons or welcome message (only visible after animation)
              Positioned(
                left: 0,
                right: 0,
                bottom: TSizes.bottomPadding,
                child: Opacity(
                  opacity: splash.buttonsOpacity.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
                    child: isLoggedIn
                        ? WelcomeContent(theme: theme, colors: colors)
                        : const AuthButtons(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
