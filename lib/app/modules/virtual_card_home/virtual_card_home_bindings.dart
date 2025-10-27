import 'package:get/get.dart';
import './virtual_card_home_controller.dart';

class VirtualCardHomeBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(VirtualCardHomeController());
    }
}