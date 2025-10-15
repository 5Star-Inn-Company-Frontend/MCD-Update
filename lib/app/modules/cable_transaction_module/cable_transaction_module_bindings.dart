import 'package:get/get.dart';
import './cable_transaction_module_controller.dart';

class CableTransactionModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(CableTransactionController());
    }
}