import 'package:get/get.dart';
import './predict_win_module_controller.dart';

class PredictWinModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictWinModuleController>(() => PredictWinModuleController());
  }
}
