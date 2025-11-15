import 'package:get/get.dart';
import './pos_term_submit_doc_module_controller.dart';

class PosTermSubmitDocModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosTermSubmitDocModuleController>(() => PosTermSubmitDocModuleController());
  }
}
