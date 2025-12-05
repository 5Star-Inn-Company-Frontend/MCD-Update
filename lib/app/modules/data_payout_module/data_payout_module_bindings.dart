import 'package:get/get.dart';
import 'package:mcd/app/modules/data_payout_module/data_payout_module_controller.dart';

class DataPayoutModuleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataPayoutController>(
      () => DataPayoutController(),
    );
  }
}
