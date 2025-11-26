import 'package:get/get.dart';
import './add_referral_module_controller.dart';

class AddReferralModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddReferralModuleController());
  }
}
