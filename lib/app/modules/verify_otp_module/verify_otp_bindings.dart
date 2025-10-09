import 'package:get/get.dart';
import 'package:mcd/app/modules/verify_otp_module/verify_otp_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class VerifyOtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyOtpController());
  }
}
