import 'package:get/get.dart';
import './my_qrcode_module_controller.dart';

class MyQrcodeModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(MyQrcodeModuleController());
    }
}