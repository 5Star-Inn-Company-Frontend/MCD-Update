import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/more_module_module/more_module_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class MoreModulePage extends GetView<MoreModuleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MoreModule Page')),
      body: Container(
        child: Obx(()=>Container(child: Text(controller.obj),)),
      ),
    );
  }
}
