import 'package:get/get.dart';
import 'package:mcd/app/modules/epin_module/data_pin/data_pin_payout_controller.dart';

class DataPinPayoutBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    
    Get.lazyPut<DataPinPayoutController>(
      () => DataPinPayoutController(
        networkName: args['networkName'] ?? '',
        networkCode: args['networkCode'] ?? '',
        networkImage: args['networkImage'] ?? '',
        designType: args['designType'] ?? '',
        quantity: args['quantity'] ?? '',
        amount: args['amount'] ?? '',
        recipient: args['recipient'] ?? '',
        coded: args['coded'] ?? '1',
      ),
    );
  }
}
