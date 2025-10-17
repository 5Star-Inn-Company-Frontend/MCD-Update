import 'package:get/get.dart';
import './add_money_module_controller.dart';

class AddMoneyModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddMoneyModuleController());
  }
}