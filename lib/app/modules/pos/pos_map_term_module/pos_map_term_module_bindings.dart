import 'package:get/get.dart';
import './pos_map_term_module_controller.dart';

class PosMapTermModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosMapTermModuleController>(() => PosMapTermModuleController());
  }
}
