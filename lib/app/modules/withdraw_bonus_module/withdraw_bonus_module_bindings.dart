import 'package:get/get.dart';
import './withdraw_bonus_module_controller.dart';

class WithdrawBonusModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(WithdrawBonusModuleController());
    }
}