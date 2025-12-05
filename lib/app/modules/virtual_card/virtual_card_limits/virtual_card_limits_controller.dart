import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualCardLimitsController extends GetxController {
  final limitController = TextEditingController();
  final isLimitEnabled = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Load saved limit if exists
    limitController.text = '12,00.00';
  }
  
  @override
  void onClose() {
    limitController.dispose();
    super.onClose();
  }
  
  void toggleLimit(bool value) {
    isLimitEnabled.value = value;
    if (!value) {
      limitController.text = '0.00';
    }
  }
  
  void setLimit() {
    if (limitController.text.isEmpty || limitController.text == '0.00') {
      Get.snackbar(
        'Error',
        'Please enter a valid limit amount',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
      );
      return;
    }
    
    Get.back();
    Get.snackbar(
      'Success',
      'Transaction limit updated successfully',
      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
      colorText: const Color(0xFF4CAF50),
    );
  }
}
