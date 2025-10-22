import 'package:get/get.dart';
import 'package:mcd/core/network/api_service.dart';
import './nin_validation_module_controller.dart';

class NinValidationModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(NinValidationModuleController());
  }
}