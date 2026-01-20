import 'package:cointrail/common/header/appHeader.dart';
import 'package:cointrail/features/home/widgets/carousel_card/home_balance_carousel.dart';
import 'package:cointrail/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import 'package:cointrail/features/home/controller/home_controller.dart';
import 'package:cointrail/core_utils/constants/text_strings.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return AppHeader(
      title: 'Welcome, ${controller.userName} 👋',
      subtitle: TTexts.header_Tagline,
      showNotification: true,
      home_carousel: HomeBalanceCarousel(),
      onNotificationTap: () async {
        Get.toNamed(TRoutes.inbox);
      },
    );
  }
}
