import 'package:get/get.dart';
import './cable_module_controller.dart';

class CableModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut<CableModuleController>(() => CableModuleController());
    }
}