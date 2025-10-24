import 'package:get/get.dart';
import './account_info_module_controller.dart';
import 'dart:developer' as dev;

class AccountInfoModuleBindings implements Bindings {
    @override
    void dependencies() {
        dev.log("AccountInfoModuleBindings: Initializing controller");
        Get.put(AccountInfoModuleController());
        dev.log("AccountInfoModuleBindings: Controller initialized successfully");
    }
}