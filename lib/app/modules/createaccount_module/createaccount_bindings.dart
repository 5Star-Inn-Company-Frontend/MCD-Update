import 'package:get/get.dart';

import 'createaccount_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class createaccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => createaccountController());
  }
}
