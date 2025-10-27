import 'package:get/get.dart';
import './virtual_card_request_controller.dart';

class VirtualCardRequestBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(VirtualCardRequestController());
  }
}
