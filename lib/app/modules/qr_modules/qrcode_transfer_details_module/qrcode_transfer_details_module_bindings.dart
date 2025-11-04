import 'package:get/get.dart';
import './qrcode_transfer_details_module_controller.dart';

class QrcodeTransferDetailsModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrcodeTransferDetailsModuleController());
  }
}
