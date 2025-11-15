import 'package:get/get.dart';
import './pos_upload_location_module_controller.dart';

class PosUploadLocationModuleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosUploadLocationModuleController>(() => PosUploadLocationModuleController());
  }
}
