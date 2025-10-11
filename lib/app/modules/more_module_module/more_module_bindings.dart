import 'package:mcd/app/modules/more_module_module/more_module_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class MoreModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MoreModuleController());
  }
}