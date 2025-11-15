import 'package:get/get.dart';
import './pos_terminal_details_module_controller.dart';

class PosTerminalDetailsModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTerminalDetailsModuleController>(() => PosTerminalDetailsModuleController());
  }
}
