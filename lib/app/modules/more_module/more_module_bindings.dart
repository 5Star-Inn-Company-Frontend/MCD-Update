import 'package:get/get.dart';
import 'package:mcd/app/modules/plans_module/plans_module_controller.dart';
import './more_module_controller.dart';

class MoreModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut(()=>MoreModuleController());
        Get.lazyPut(()=>PlansModuleController());
    }
}