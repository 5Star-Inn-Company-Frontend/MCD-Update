import 'package:get/get.dart';
import './pos_term_agreement_module_controller.dart';

class PosTermAgreementModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTermAgreementModuleController>(() => PosTermAgreementModuleController());
  }
}
