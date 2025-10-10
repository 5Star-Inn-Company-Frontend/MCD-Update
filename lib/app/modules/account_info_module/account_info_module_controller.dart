import 'package:get/get.dart';
import 'package:mcd/app/modules/login_screen_module/login_screen_controller.dart';

class AccountInfoModuleController extends GetxController {
  final LoginScreenController authController = Get.put(LoginScreenController());
  late final user = authController.dashboardData.value;
}