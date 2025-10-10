import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_asset.dart';
import '../../../core/constants/app_widgets.dart';
import '../../styles/app_colors.dart';
import 'splash_screen_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class SplashScreenPage extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAsset.splash), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppWidgets()
                .logoIcon
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .shimmer(
                    delay: 200.ms,
                    duration: 1200.ms,
                    color: AppColors.primaryColor.withOpacity(.4))
                .shake(hz: 4, curve: Curves.easeInOutCubic)
                .scaleXY(end: 1.1, duration: 600.ms)
                .then(delay: 600.ms)
                .scaleXY(end: 1 / 1.1),
            const Gap(10),
            AppWidgets().appTextName
          ],
        ),
      ),
    );
  }
}
