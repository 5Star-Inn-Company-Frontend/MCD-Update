import 'package:get/get.dart';
import 'giveaway_detail_controller.dart';

class GiveawayDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GiveawayDetailController>(
      () => GiveawayDetailController(),
    );
  }
}
