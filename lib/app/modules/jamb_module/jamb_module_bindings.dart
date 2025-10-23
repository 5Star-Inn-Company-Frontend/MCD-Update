import 'package:get/get.dart';
import './jamb_module_controller.dart';

class JambModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(JambModuleController());
    }
}