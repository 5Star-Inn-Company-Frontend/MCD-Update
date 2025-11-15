import 'package:get/get.dart';
import './pos_home_module_controller.dart';

class PosHomeModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosHomeModuleController>(() => PosHomeModuleController());
  }
}
