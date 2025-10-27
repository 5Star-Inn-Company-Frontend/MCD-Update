import 'package:get/get.dart';
import './giveaway_module_controller.dart';

class GiveawayModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(GiveawayModuleController());
    }
}