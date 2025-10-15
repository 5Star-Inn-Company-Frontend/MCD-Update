import 'package:get/get.dart';
import './data_module_controller.dart';

class DataModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(DataModuleController());
    }
}