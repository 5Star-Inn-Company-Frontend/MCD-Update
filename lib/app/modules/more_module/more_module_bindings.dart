import 'package:get/get.dart';
import './more_module_controller.dart';

class MoreModuleBindings implements Bindings {
    @override
    void dependencies() {
      print('MoreModuleBindings dependencies called');
        Get.lazyPut(()=>MoreModuleController());
    }
}