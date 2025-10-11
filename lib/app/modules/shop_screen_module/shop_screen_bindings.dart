import 'package:mcd/app/modules/shop_screen_module/shop_screen_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ShopScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopScreenController());
  }
}