import 'package:get/get.dart';
import './card_topup_module_controller.dart';

class CardTopupModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CardTopupModuleController>(() => CardTopupModuleController());
  }
}
