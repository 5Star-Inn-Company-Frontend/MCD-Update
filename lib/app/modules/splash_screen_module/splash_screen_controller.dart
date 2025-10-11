import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_pages.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class SplashScreenController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = box.read('token');
    if (token != null && token.toString().isNotEmpty) {
      Get.offAllNamed(Routes.HOME_SCREEN);
    } else {
      Get.offAllNamed(Routes.LOGIN_SCREEN);
    }
  }
}
