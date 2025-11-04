import 'package:get/get.dart';
import './qrcode_transfer_module_controller.dart';

class QrcodeTransferModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrcodeTransferModuleController());
  }
}
