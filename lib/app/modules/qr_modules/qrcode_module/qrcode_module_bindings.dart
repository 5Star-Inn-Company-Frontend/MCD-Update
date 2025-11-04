import 'package:get/get.dart';
import './qrcode_module_controller.dart';

class QrcodeModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrcodeModuleController());
  }
}
