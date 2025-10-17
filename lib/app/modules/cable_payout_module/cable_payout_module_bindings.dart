import 'package:get/get.dart';
import 'package:mcd/core/network/api_service.dart';
import './cable_payout_module_controller.dart';

class CablePayoutModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.lazyPut(() => ApiService());
        Get.put(CablePayoutController());
    }
}