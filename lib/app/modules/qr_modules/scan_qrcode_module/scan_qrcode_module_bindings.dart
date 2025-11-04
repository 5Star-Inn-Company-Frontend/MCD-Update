import 'package:get/get.dart';
import './scan_qrcode_module_controller.dart';

class ScanQrcodeModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanQrcodeModuleController());
  }
}
