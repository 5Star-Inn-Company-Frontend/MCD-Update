import 'package:get/get.dart';
import 'package:mcd/core/network/api_service.dart';
import './electricity_payout_module_controller.dart';

class ElectricityPayoutModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut(() => ApiService());
        Get.put(ElectricityPayoutController());
    }
}