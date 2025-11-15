import 'package:get/get.dart';
import './pos_terminal_transaction_history_module_controller.dart';

class PosTerminalTransactionHistoryModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTerminalTransactionHistoryModuleController>(() => PosTerminalTransactionHistoryModuleController());
  }
}
