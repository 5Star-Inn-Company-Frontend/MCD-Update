import 'package:get/get.dart';
import 'package:mcd/app/modules/nin_validation_module/nin_validation_payout_controller.dart';

class NinValidationPayoutBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    
    Get.lazyPut<NinValidationPayoutController>(
      () => NinValidationPayoutController(
        ninNumber: args['ninNumber'] ?? '',
        amount: args['amount'] ?? '2500',
      ),
    );
  }
}
