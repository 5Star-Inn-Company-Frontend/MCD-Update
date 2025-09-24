import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:mcd/routes/app_routes.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  Future<void> checkAuth(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final token = box.read('token');
    if (token != null && token.toString().isNotEmpty) {
      Get.offAllNamed(AppRoutes.homenav);
      } else {
      Get.offAllNamed(AppRoutes.authenticate);
    }
  }
}
