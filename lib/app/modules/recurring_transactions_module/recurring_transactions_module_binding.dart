import 'package:get/get.dart';
import './recurring_transactions_module_controller.dart';

class RecurringTransactionsModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecurringTransactionsModuleController>(
      () => RecurringTransactionsModuleController(),
    );
  }
}
