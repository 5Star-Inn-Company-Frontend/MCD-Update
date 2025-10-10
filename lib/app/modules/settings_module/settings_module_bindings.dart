import 'package:get/get.dart';
import './settings_module_controller.dart';

class SettingsModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(SettingsModuleController());
    }
}