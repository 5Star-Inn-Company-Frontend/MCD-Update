import 'package:get/get.dart';
import 'package:mcd/app/modules/momo_module/momo_module_controller.dart';

class MomoModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MomoModuleController>(
      () => MomoModuleController(),
    );
  }
}
