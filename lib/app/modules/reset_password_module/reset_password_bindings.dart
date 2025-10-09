import 'package:get/get.dart';
import 'package:mcd/app/modules/reset_password_module/reset_password_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ResetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController());
  }
}
