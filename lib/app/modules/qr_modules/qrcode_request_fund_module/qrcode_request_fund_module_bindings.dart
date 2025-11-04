import 'package:get/get.dart';
import './qrcode_request_fund_module_controller.dart';

class QrcodeRequestFundModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrcodeRequestFundModuleController());
  }
}
