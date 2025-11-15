import 'package:get/get.dart';
import './pos_terminal_settings_module_controller.dart';

class PosTerminalSettingsModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTerminalSettingsModuleController>(() => PosTerminalSettingsModuleController());
  }
}
