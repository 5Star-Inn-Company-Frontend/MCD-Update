import 'package:get/get.dart';
import './cable_payout_module_controller.dart';

class CablePayoutModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(CablePayoutController());
    }
}