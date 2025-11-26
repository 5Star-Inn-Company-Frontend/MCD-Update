import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class CardTopupModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final amountController = TextEditingController();
  
  final isLoading = false.obs;
  final cardType = ''.obs; // visa, mastercard, verve, etc.
  
  @override
  void onInit() {
    super.onInit();
    dev.log('CardTopupModuleController initialized', name: 'CardTopup');
    
    // Add listener to card number for card type detection
    cardNumberController.addListener(_detectCardType);
  }
  
  @override
  void onClose() {
    cardNumberController.dispose();
    cardNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    amountController.dispose();
    super.onClose();
  }
  
  void _detectCardType() {
    final number = cardNumberController.text.replaceAll(' ', '');
    if (number.isEmpty) {
      cardType.value = '';
      return;
    }
    
    // Visa: starts with 4
    if (number.startsWith('4')) {
      cardType.value = 'visa';
    }
    // Mastercard: starts with 51-55 or 2221-2720
    else if (number.startsWith(RegExp(r'^5[1-5]')) || 
             number.startsWith(RegExp(r'^2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[0-1][0-9]|720)'))) {
      cardType.value = 'mastercard';
    }
    // Verve: starts with 506 or 650
    else if (number.startsWith('506') || number.startsWith('650')) {
      cardType.value = 'verve';
    }
    else {
      cardType.value = '';
    }
  }
  
  String formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }
  
  String formatExpiryDate(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }
  
  Future<void> processTopup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      dev.log('Processing card top-up', name: 'CardTopup');
      
      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null) {
        dev.log('Utility URL not found', name: 'CardTopup', error: 'URL missing');
        Get.snackbar(
          'Error',
          'Service configuration error. Please login again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      
      final body = {
        'card_number': cardNumberController.text.replaceAll(' ', ''),
        'card_name': cardNameController.text,
        'expiry_date': expiryDateController.text,
        'cvv': cvvController.text,
        'amount': amountController.text,
      };
      
      dev.log('Sending card top-up request', name: 'CardTopup');
      
      final result = await apiService.postrequest('${utilityUrl}card-topup', body);
      
      result.fold(
        (failure) {
          dev.log('Card top-up failed', name: 'CardTopup', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            dev.log('Card top-up successful', name: 'CardTopup');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Top-up successful',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            
            // Clear form
            _clearForm();
            
            // Navigate back or to success page
            Get.back();
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Top-up failed',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error processing card top-up', name: 'CardTopup', error: e);
      Get.snackbar(
        'Error',
        'An error occurred while processing your request',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void _clearForm() {
    cardNumberController.clear();
    cardNameController.clear();
    expiryDateController.clear();
    cvvController.clear();
    amountController.clear();
    cardType.value = '';
  }
}
