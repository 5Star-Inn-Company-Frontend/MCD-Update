import 'package:get/get.dart';
import './pos_term_otp_module_controller.dart';

class PosTermOtpModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTermOtpModuleController>(() => PosTermOtpModuleController());
  }
}
