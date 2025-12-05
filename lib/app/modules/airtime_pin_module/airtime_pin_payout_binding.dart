import 'package:get/get.dart';
import 'package:mcd/app/modules/airtime_pin_module/airtime_pin_payout_controller.dart';

class AirtimePinPayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AirtimePinPayoutController>(
      () => AirtimePinPayoutController(),
    );
  }
}
