import 'package:get/get.dart';
import './game_centre_module_controller.dart';

class GameCentreModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GameCentreModuleController());
  }
}
