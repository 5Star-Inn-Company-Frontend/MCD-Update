import 'package:get/get.dart';
import './electricity_transaction_module_controller.dart';

class ElectricityTransactionModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ElectricityTransactionController());
    }
}