import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/reset_password_module/reset_password_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ResetPasswordPage extends GetView<ResetPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ResetPassword Page')),
      body: Container(
        child: Obx(() => Container(
              child: Text(controller.obj),
            )),
      ),
    );
  }
}
