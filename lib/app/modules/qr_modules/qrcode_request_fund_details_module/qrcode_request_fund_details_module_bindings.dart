import 'package:get/get.dart';
import './qrcode_request_fund_details_module_controller.dart';

class QrcodeRequestFundDetailsModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrcodeRequestFundDetailsModuleController());
  }
}
