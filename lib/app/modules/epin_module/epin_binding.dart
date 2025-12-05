import 'package:get/get.dart';
import 'epin_controller.dart';

class EpinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EpinController());
  }
}
