import 'package:get/get.dart';
import './change_pwd_module_controller.dart';

class ChangePwdModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut<ChangePwdModuleController>(() => ChangePwdModuleController());
    }
}