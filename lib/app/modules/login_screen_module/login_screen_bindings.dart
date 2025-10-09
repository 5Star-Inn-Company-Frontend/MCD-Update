import 'package:get/get.dart';

import 'login_screen_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class LoginScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenController());
  }
}
