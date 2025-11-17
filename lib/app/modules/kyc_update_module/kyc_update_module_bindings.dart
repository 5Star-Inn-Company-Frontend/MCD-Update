import 'package:get/get.dart';
import './kyc_update_module_controller.dart';

class KycUpdateModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KycUpdateModuleController());
  }
}
