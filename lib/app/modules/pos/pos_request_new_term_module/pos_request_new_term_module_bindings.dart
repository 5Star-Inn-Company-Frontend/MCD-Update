import 'package:get/get.dart';
import './pos_request_new_term_module_controller.dart';

class PosRequestNewTermModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosRequestNewTermModuleController>(() => PosRequestNewTermModuleController());
  }
}
