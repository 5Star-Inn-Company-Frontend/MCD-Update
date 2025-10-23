import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class JambVerfyAccountModuleController extends GetxController {
  final profileCodeController = TextEditingController();
  final isLoading = false.obs;
  final isValidating = false.obs;
  String? selectedOption;
  String? selectedOptionTitle;
  String? amount;

  final apiService = DioApiService();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['selectedOption'] != null) {
      selectedOption = args['selectedOption'];
      _setAmountBasedOnOption();
    }
  }

  void _setAmountBasedOnOption() {
    switch (selectedOption) {
      case 'de':
        amount = '6200';
        selectedOptionTitle = 'Direct Entry (DE)';
        break;
      case 'utme_with_mock':
        amount = '7700';
        selectedOptionTitle = 'UTME PIN (with mock)';
        break;
      case 'utme_without_mock':
        amount = '6200';
        selectedOptionTitle = 'UTME PIN (without mock)';
        break;
      default:
        amount = '0';
        selectedOptionTitle = 'Unknown';
    }
    dev.log('Amount set to: ₦$amount for option: $selectedOption', name: 'JambVerify');
  }

  @override
  void onClose() {
    profileCodeController.dispose();
    super.onClose();
  }

  Future<void> pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      profileCodeController.text = clipboardData.text!;
    }
  }

  Future<void> verifyAccount() async {
    if (profileCodeController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter profile code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isValidating.value = true;
    dev.log('Starting account validation for profile code: ${profileCodeController.text}', name: 'JambVerify');

    // Simulate validation delay
    await Future.delayed(const Duration(seconds: 2));

    isValidating.value = false;

    dev.log('Validation successful, navigating to payment', name: 'JambVerify');
    Get.toNamed(
      Routes.JAMB_PAYMENT_MODULE,
      arguments: {
        'selectedOption': selectedOption,
        'selectedOptionTitle': selectedOptionTitle,
        'profileCode': profileCodeController.text,
        'amount': amount,
      },
    );
  }
}