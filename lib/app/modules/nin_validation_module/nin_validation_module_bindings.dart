import 'package:get/get.dart';
import './nin_validation_module_controller.dart';

class NinValidationModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NinValidationModuleController>(() => NinValidationModuleController());
  }
}