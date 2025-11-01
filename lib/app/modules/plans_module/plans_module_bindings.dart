import 'package:get/get.dart';
import './plans_module_controller.dart';

class PlansModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlansModuleController());
  }
}