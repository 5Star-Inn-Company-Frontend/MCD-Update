import 'package:get/get.dart';
import 'virtual_card_full_details_controller.dart';

class VirtualCardFullDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualCardFullDetailsController>(() => VirtualCardFullDetailsController());
  }
}
