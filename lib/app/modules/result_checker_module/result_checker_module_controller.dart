import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';

class ResultCheckerModuleController extends GetxController {
  final selectedValue = Rx<String?>(null);
  final items = <String>["Waec", "Neco", "JAMB"];
  final optionType = Rx<String>('token');
  final pageTitle = Rx<String>('Result Checker Token');
  
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    selectedValue.value = items.first;
    
    // Get the option type from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['type'] != null) {
      optionType.value = args['type'];
      _updatePageTitle();
    }
  }

  void _updatePageTitle() {
    switch (optionType.value) {
      case 'token':
        pageTitle.value = 'Result Checker Token';
        break;
      case 'jamb':
        pageTitle.value = 'JAMB Pin';
        break;
      case 'registration':
        pageTitle.value = 'Registration Pin';
        break;
      default:
        pageTitle.value = 'Result Checker';
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void selectExam(String value) {
    selectedValue.value = value;
  }

  void handlePayment() {
    // Implement payment logic here
    Get.snackbar(
      'Payment',
      'Processing ${pageTitle.value} for ${selectedValue.value}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successBgColor,
      colorText: AppColors.textSnackbarColor,
    );
  }
}