import 'package:get/get.dart';
import './virtual_card_details_controller.dart';

class VirtualCardDetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(VirtualCardDetailsController());
  }
}
