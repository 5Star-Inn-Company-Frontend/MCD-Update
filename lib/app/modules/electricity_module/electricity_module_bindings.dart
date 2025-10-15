import 'package:get/get.dart';
import './electricity_module_controller.dart';

class ElectricityModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ElectricityModuleController());
    }
}