import 'package:get/get.dart';
import './jamb_verfy_account_module_controller.dart';

class JambVerfyAccountModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(JambVerfyAccountModuleController());
    }
}