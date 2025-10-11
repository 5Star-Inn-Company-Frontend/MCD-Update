import 'package:mcd/app/modules/assistant_screen_module/assistant_screen_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class AssistantScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssistantScreenController());
  }
}