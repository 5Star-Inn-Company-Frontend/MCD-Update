import 'package:get/get.dart';

import 'home_navigation_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeNavigationController());
  }
}
