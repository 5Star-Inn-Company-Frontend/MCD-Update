import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/app_asset.dart';

class ResultCheckerModuleController extends GetxController {
  final selectedValue = Rx<String?>(null);
  final selectedExam = Rx<Map<String, String>?>(null);
  
  final exams = <Map<String, String>>[
    {'name': 'WAEC', 'logo': AppAsset.waec, 'code': 'waec'},
    {'name': 'NECO', 'logo': AppAsset.neco, 'code': 'neco'},
    {'name': 'NABTEB', 'logo': AppAsset.nabteb, 'code': 'nabteb'},
  ];
  
  final items = <String>["NECO", "WAEC"];
  final optionType = Rx<String>('token');
  final pageTitle = Rx<String>('Result Checker Token');
  
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    selectedValue.value = items.first;
    selectedExam.value = exams.firstWhere((exam) => exam['name'] == 'NECO');
    
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

  void selectExamByObject(Map<String, String> exam) {
    selectedExam.value = exam;
    selectedValue.value = exam['name'];
  }

  void handlePayment() {
    // Validate inputs
    if (selectedExam.value == null) {
      Get.snackbar(
        'Error',
        'Please select an exam type',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    final quantity = amountController.text.trim();
    if (quantity.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter quantity (1-10)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    final quantityInt = int.tryParse(quantity);
    if (quantityInt == null || quantityInt < 1 || quantityInt > 10) {
      Get.snackbar(
        'Error',
        'Quantity must be between 1 and 10',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    // Calculate total amount (₦1200 per token)
    final totalAmount = (quantityInt * 1200).toString();

    // Navigate to payout screen
    Get.toNamed(
      Routes.RESULT_CHECKER_PAYOUT,
      arguments: {
        'examName': selectedExam.value!['name'],
        'examLogo': selectedExam.value!['logo'],
        'examCode': selectedExam.value!['code'],
        'quantity': quantity,
        'amount': totalAmount,
      },
    );
  }
}