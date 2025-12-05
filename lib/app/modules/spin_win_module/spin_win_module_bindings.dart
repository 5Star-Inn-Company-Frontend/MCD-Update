import 'package:get/get.dart';
import './spin_win_module_controller.dart';

class SpinWinModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpinWinModuleController>(() => SpinWinModuleController());
  }
}
