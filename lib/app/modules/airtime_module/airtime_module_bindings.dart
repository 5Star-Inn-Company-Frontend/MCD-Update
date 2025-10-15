import 'package:get/get.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_controller.dart';
import './airtime_module_controller.dart';

class AirtimeModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(AirtimeModuleController());
        Get.put(TransactionDetailModuleController());
    }
}