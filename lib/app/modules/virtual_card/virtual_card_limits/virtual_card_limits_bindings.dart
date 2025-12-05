import 'package:get/get.dart';
import 'virtual_card_limits_controller.dart';

class VirtualCardLimitsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualCardLimitsController>(() => VirtualCardLimitsController());
  }
}
