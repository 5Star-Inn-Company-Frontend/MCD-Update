import 'package:get/get.dart';
import 'package:mcd/app/modules/epin_module/epin_payout_controller.dart';

class EpinPayoutBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    
    Get.lazyPut<EpinPayoutController>(
      () => EpinPayoutController(
        networkName: args['networkName'] ?? '',
        networkCode: args['networkCode'] ?? '',
        networkImage: args['networkImage'] ?? '',
        designType: args['designType'] ?? '',
        quantity: args['quantity'] ?? '',
        amount: args['amount'] ?? '',
        recipient: args['recipient'] ?? '',
      ),
    );
  }
}
