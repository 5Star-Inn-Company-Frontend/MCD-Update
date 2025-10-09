import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/pin_verify_module/pin_verify_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class PinVerifyPage extends GetView<PinVerifyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PinVerify Page')),
      body: Container(
        child: Obx(() => Container(
              child: Text(controller.obj),
            )),
      ),
    );
  }
}
