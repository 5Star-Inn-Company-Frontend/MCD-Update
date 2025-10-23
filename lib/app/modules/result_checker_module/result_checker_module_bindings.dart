import 'package:get/get.dart';
import './result_checker_module_controller.dart';

class ResultCheckerModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ResultCheckerModuleController());
    }
}