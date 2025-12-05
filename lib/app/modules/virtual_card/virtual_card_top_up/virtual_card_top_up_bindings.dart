import 'package:get/get.dart';
import 'virtual_card_top_up_controller.dart';

class VirtualCardTopUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualCardTopUpController>(() => VirtualCardTopUpController());
  }
}
