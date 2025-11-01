import 'package:get/get.dart';
import './number_verification_module_controller.dart';

class NumberVerificationModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NumberVerificationModuleController());
  }
}
