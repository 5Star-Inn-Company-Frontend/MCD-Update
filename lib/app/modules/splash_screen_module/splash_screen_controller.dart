import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer' as dev;

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
    dev.log("SplashScreenController initialized");
    checkAuth();
  }

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = box.read('token');
    dev.log("Token check: ${token != null ? 'exists' : 'null'}");
    
    if (token != null && token.toString().isNotEmpty) {
      dev.log("Token found, navigating to HOME_SCREEN");
      Get.offAllNamed(Routes.HOME_SCREEN);
    } else {
      dev.log("No token found, navigating to LOGIN_SCREEN");
      Get.offAllNamed(Routes.LOGIN_SCREEN);
    }
  }
}
