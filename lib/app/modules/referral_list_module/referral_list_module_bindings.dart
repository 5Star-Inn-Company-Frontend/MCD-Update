import 'package:get/get.dart';
import './referral_list_module_controller.dart';

class ReferralListModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralListModuleController>(() => ReferralListModuleController());
  }
}
