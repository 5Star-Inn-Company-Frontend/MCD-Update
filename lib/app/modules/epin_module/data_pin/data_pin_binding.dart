import 'package:get/get.dart';
import 'data_pin_controller.dart';

class DataPinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataPinController());
  }
}
