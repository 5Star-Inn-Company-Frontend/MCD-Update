import 'package:get/get.dart';
import './notification_module_controller.dart';

class NotificationModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationModuleController());
  }
}