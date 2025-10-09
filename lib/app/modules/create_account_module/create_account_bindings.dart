import 'package:get/get.dart';

import 'create_account_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class CreateAccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateAccountController());
  }
}