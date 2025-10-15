import 'package:get/get.dart';
import './betting_module_controller.dart';

class BettingModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(BettingModuleController());
    }
}