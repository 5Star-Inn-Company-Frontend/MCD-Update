import 'package:get/get.dart';
import './pos_authorize_withdrawal_module_controller.dart';

class PosAuthorizeWithdrawalModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosAuthorizeWithdrawalModuleController>(() => PosAuthorizeWithdrawalModuleController());
  }
}
