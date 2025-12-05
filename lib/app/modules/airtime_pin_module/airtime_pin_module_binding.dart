import 'package:get/get.dart';
import 'airtime_pin_module_controller.dart';

class AirtimePinModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AirtimePinModuleController>(() => AirtimePinModuleController());
  }
}
