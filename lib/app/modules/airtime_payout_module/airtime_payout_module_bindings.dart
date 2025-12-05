import 'package:get/get.dart';
import 'package:mcd/app/modules/airtime_payout_module/airtime_payout_module_controller.dart';

class AirtimePayoutModuleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AirtimePayoutController>(
      () => AirtimePayoutController(),
    );
  }
}
