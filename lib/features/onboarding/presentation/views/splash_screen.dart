import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/app_widgets.dart';
import 'package:mcd/features/auth/presentation/controllers/splash_controller.dart';
// import 'package:mcd/features/auth/presentation/views/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Future<void> _toOnboard() async {
  //   // context.goNamed(Routes.authenticate);
  //   // MaterialApp.router
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const Authenticate()),
  //           (Route<dynamic> route) => true);
  // }

  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 3), _toOnboard);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    controller.checkAuth(context);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAsset.splash), fit: BoxFit.fill)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppWidgets().logoIcon.animate(
            onPlay: (controller) =>
                controller.repeat(reverse: true))
            .shimmer(
            delay: 200.ms,
            duration: 1200.ms,
            color: AppColors.primaryColor.withOpacity(.4)).shake(hz: 4, curve: Curves.easeInOutCubic).scaleXY(end: 1.1, duration: 600.ms)
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