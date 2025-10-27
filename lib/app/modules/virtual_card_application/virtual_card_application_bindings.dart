import 'package:get/get.dart';
import './virtual_card_application_controller.dart';

class VirtualCardApplicationBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(VirtualCardApplicationController());
  }
}
