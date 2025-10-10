import 'package:get/get.dart';
import './account_info_module_controller.dart';

class AccountInfoModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(AccountInfoModuleController());
    }
}