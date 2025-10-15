import 'package:get/get.dart';
import './electricity_payout_module_controller.dart';

class ElectricityPayoutModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ElectricityPayoutController());
    }
}