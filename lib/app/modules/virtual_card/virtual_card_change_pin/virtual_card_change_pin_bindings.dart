import 'package:get/get.dart';
import 'virtual_card_change_pin_controller.dart';

class VirtualCardChangePinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualCardChangePinController>(() => VirtualCardChangePinController());
  }
}
