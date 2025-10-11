import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/history_screen_module/history_screen_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HistoryScreenPage extends GetView<HistoryScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HistoryScreen Page')),
      body: Container(
        child: Obx(()=>Container(child: Text(controller.obj),)),
      ),
    );
  }
}
