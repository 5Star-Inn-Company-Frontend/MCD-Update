import 'package:mcd/app/modules/history_screen_module/history_screen_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HistoryScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryScreenController());
  }
}