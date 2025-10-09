import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_device_verify_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class NewDeviceVerifyPage extends GetView<NewDeviceVerifyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NewDeviceVerify Page')),
      body: Container(
        child: Obx(() => Container(
              child: Text(controller.obj),
            )),
      ),
    );
  }
}
