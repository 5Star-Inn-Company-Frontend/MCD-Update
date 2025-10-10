import 'package:mcd/core/import/imports.dart';

class MoreModuleController extends GetxController {
  final LoginScreenController authController = Get.find<LoginScreenController>();
  
  Future<void> logoutUser() async {
    await authController.logout();
    Get.offAllNamed(Routes.LOGIN_SCREEN);
  }
}