import 'package:get/get.dart';
import 'package:mcd/app/modules/epin_module/epin_transaction_detail_controller.dart';

class EpinTransactionDetailBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>;
    
    Get.lazyPut<EpinTransactionDetailController>(
      () => EpinTransactionDetailController(
        networkName: args['networkName'] ?? '',
        networkImage: args['networkImage'] ?? '',
        amount: args['amount'] ?? '',
        designType: args['designType'] ?? '',
        quantity: args['quantity'] ?? '',
        paymentMethod: args['paymentMethod'] ?? '',
        transactionId: args['transactionId'] ?? '',
        postedDate: args['postedDate'] ?? '',
        transactionDate: args['transactionDate'] ?? '',
        token: args['token'] ?? '',
      ),
    );
  }
}
