import 'package:get/get.dart';
import 'package:mcd/app/modules/result_checker_module/result_checker_payout_controller.dart';

class ResultCheckerPayoutBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    
    Get.lazyPut<ResultCheckerPayoutController>(
      () => ResultCheckerPayoutController(
        examName: args['examName'] ?? '',
        examLogo: args['examLogo'] ?? '',
        examCode: args['examCode'] ?? '',
        quantity: args['quantity'] ?? '',
        amount: args['amount'] ?? '',
      ),
    );
  }
}
