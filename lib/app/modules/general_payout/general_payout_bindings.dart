import 'package:get/get.dart';
import 'general_payout_controller.dart';

class GeneralPayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneralPayoutController>(() => GeneralPayoutController());
  }
}
