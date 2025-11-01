import 'package:get/get.dart';
import './transaction_detail_module_controller.dart';

class TransactionDetailModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut(() => TransactionDetailModuleController());
    }
}