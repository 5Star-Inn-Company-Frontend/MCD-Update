import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_account_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class CreateAccountPage extends GetView<CreateAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CreateAccount Page')),
      body: Container(
        child: Obx(() => Container(
              child: Text(controller.obj),
            )),
      ),
    );
  }
}
