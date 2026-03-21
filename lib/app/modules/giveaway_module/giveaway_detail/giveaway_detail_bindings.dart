import 'package:get/get.dart';
import 'package:mcd/app/modules/giveaway_module/giveaway_module_controller.dart';
import 'giveaway_detail_controller.dart';

class GiveawayDetailBindings extends Bindings {
  @override
  void dependencies() {
    // ensure parent controller is available for detail fetching & claiming
    if (!Get.isRegistered<GiveawayModuleController>()) {
      Get.put(GiveawayModuleController());
    }
    Get.lazyPut<GiveawayDetailController>(
      () => GiveawayDetailController(),
    );
  }
}
