import 'package:get/get.dart';
import 'package:mcd/app/modules/pin_verify_module/pin_verify_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class PinVerifyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PinVerifyController());
  }
}
