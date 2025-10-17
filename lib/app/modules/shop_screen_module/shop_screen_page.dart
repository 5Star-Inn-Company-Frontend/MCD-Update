import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/shop_screen_module/shop_screen_controller.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ShopScreenPage extends GetView<ShopScreenController> {
  const ShopScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ShopScreen Page')),
      body: Container(
        child: Obx(()=>Container(child: Text(controller.obj),)),
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 2),
    );
  }
}
