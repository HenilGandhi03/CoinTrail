import 'package:flutter/material.dart';

class WelcomeContent extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colors;

  const WelcomeContent({required this.theme, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome back 👋',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Let’s track your finances',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSecondary,
          ),
        ),
      ],
    );
  }
}
