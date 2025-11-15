import 'package:get/get.dart';
import './pos_term_req_form_module_controller.dart';

class PosTermReqFormModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTermReqFormModuleController>(() => PosTermReqFormModuleController());
  }
}
