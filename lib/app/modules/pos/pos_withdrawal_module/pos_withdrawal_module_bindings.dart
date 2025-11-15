import 'package:get/get.dart';
import './pos_withdrawal_module_controller.dart';

class PosWithdrawalModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosWithdrawalModuleController>(() => PosWithdrawalModuleController());
  }
}
