import 'package:get/get.dart';
import './leaderboard_module_controller.dart';

class LeaderboardModuleBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaderboardModuleController());
  }
}