import 'package:get/get.dart';

import 'splash_screen_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}
