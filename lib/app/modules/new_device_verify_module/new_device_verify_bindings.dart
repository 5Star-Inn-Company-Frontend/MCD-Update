import 'package:get/get.dart';

import 'new_device_verify_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class NewDeviceVerifyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewDeviceVerifyController());
  }
}
