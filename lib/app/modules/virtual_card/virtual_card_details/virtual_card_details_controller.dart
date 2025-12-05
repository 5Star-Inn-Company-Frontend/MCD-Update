import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualCardDetailsController extends GetxController {
  final pageController = PageController();
  final isCardDetailsHidden = true.obs;
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
