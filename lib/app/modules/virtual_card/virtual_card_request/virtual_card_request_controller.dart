import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class VirtualCardRequestController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final amountController = TextEditingController();

  final selectedCurrency1 = ''.obs;
  final selectedCardType = ''.obs;
  final isCreating = false.obs;

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  Future<void> createVirtualCard() async {
    try {
      if (selectedCurrency1.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select currency',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      if (selectedCardType.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select card type',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      if (amountController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter amount',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      isCreating.value = true;
      dev.log('Creating virtual card');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      String currency = selectedCurrency1.value.toUpperCase();
      if (currency == 'DOLLAR') currency = 'USD';
      if (currency == 'NAIRA') currency = 'NGN';
      if (currency == 'POUND') currency = 'GBP';

      String brand = selectedCardType.value.toLowerCase();
      if (brand == 'master card') brand = 'mastercard';
      if (brand == 'visa card') brand = 'visa';

      final body = {
        'currency': currency,
        'amount': amountController.text,
        'brand': brand,
      };

      final result = await apiService.postrequest(
        '${transactionUrl}virtual-card/create',
        body,
      );

      result.fold(
        (failure) {
          dev.log('Error: ${failure.message}');
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            dev.log('Success: ${data['message']}');
            Get.snackbar(
              'Success',
              data['message']?.toString() ?? 'Virtual card created successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            Get.back();
          } else {
            dev.log('Error: ${data['message']}');
            Get.snackbar(
              'Error',
              data['message']?.toString() ?? 'Failed to create card',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isCreating.value = false;
    }
  }
}
