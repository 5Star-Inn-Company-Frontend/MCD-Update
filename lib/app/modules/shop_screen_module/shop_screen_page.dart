import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/shop_screen_module/shop_screen_controller.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/core/import/imports.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ShopScreenPage extends GetView<ShopScreenController> {
  const ShopScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context) ?? false;
      },
      child: Scaffold(
      appBar: AppBar(title: Text('ShopScreen Page')),
      body: Container(
        child: Obx(()=>Container(child: Text(controller.obj),)),
      ),
        bottomNavigationBar: const BottomNavigation(selectedIndex: 2),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: TextSemiBold('Exit App'),
        content: TextSemiBold('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: TextSemiBold('No', color: AppColors.textPrimaryColor,),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: TextSemiBold('Yes', color: AppColors.textPrimaryColor,),
          ),
        ],
      ),
    );
  }
}
