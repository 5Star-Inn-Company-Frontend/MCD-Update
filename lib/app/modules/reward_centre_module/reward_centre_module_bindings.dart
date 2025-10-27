import 'package:get/get.dart';
import './reward_centre_module_controller.dart';

class RewardCentreModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(RewardCentreModuleController());
    }
}