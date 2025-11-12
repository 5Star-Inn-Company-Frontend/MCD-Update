import 'package:get/get.dart';
import './a2c_module_controller.dart';

class A2CModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut<A2CModuleController>(() => A2CModuleController());
    }
}