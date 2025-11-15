import 'package:get/get.dart';
import './pos_terminal_requests_module_controller.dart';

class PosTerminalRequestsModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTerminalRequestsModuleController>(() => PosTerminalRequestsModuleController());
  }
}
