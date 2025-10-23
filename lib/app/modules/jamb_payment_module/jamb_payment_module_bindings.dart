import 'package:get/get.dart';
import './jamb_payment_module_controller.dart';

class JambPaymentModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(JambPaymentModuleController());
    }
}
