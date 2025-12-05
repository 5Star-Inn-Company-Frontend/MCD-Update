import 'package:get/get.dart';
import 'virtual_card_transactions_controller.dart';

class VirtualCardTransactionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualCardTransactionsController>(() => VirtualCardTransactionsController());
  }
}
