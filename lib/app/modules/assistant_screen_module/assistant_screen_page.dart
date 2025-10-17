import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/assistant_screen_module/assistant_screen_controller.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class AssistantScreenPage extends GetView<AssistantScreenController> {
  const AssistantScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AssistantScreen Page')),
      body: Container(
        child: Obx(()=>Container(child: Text(controller.obj),)),
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 3),
    );
  }
}
