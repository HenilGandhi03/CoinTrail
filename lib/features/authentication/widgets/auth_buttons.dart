import 'package:cointrail/common/buttons/primary_button.dart';
import 'package:cointrail/core_utils/constants/sizes.dart';
import 'package:cointrail/core_utils/constants/text_strings.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TPrimaryButton(
          text: TTexts.signUp,
          onPressed: () => Get.toNamed(TRoutes.register),
        ),
        const SizedBox(height: TSizes.sm),
        TPrimaryButton(
          text: TTexts.login,
          onPressed: () => Get.toNamed(TRoutes.login),
        ),
      ],
    );
  }
}
