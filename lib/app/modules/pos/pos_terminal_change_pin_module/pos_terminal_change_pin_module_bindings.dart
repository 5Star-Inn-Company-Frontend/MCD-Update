import 'package:get/get.dart';
import './pos_terminal_change_pin_module_controller.dart';

class PosTerminalChangePinModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTerminalChangePinModuleController>(() => PosTerminalChangePinModuleController());
  }
}
