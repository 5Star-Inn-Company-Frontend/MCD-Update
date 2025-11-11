import 'package:get/get.dart';
import './change_pin_module_controller.dart';

class ChangePinModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut<ChangePinModuleController>(() => ChangePinModuleController());
    }
}