import 'package:get/get.dart';
import './ussd_topup_module_controller.dart';

class UssdTopupModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UssdTopupModuleController>(() => UssdTopupModuleController());
  }
}
