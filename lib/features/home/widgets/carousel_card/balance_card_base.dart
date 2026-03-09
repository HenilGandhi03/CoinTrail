import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BalanceCardBase extends StatelessWidget {
  final Widget child;
  final Gradient gradient;

  const BalanceCardBase({
    super.key,
    required this.child,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 160, // Fixed height to prevent overflow
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        gradient: gradient,
      ),
      child: child,
    );
  }
}
