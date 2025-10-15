import 'package:get/get.dart';
import 'package:mcd/app/modules/airtime_module/airtime_module_controller.dart';
import './transaction_detail_module_controller.dart';

class TransactionDetailModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(TransactionDetailModuleController());
        Get.put(AirtimeModuleController());
    }
}