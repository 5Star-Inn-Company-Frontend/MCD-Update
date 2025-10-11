import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/shop_screen_module/shop_screen_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ShopScreenPage extends GetView<ShopScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ShopScreen Page')),
      body: Container(
        child: Obx(()=>Container(child: Text(controller.obj),)),
      ),
    );
  }
}
