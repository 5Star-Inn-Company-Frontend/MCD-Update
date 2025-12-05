import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class NinValidationPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final String ninNumber;
  final String amount;

  NinValidationPayoutController({
    required this.ninNumber,
    required this.amount,
  });

  final TextEditingController promoCodeController = TextEditingController();

  final isPaying = false.obs;
  final selectedPaymentMethod = 1.obs;
  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('NinValidationPayoutController initialized', name: 'NinValidationPayout');
    _fetchBalances();
  }

  Future<void> _fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'NinValidationPayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'NinValidationPayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'NinValidationPayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'NinValidationPayout', error: e);
    }
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'NinValidationPayout');
    }
  }

  void clearPromoCode() {
    promoCodeController.clear();
  }

  Future<void> confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming NIN validation payment', name: 'NinValidationPayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'NinValidationPayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", 
          backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'mcd_${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "number": ninNumber,
        "ref": ref,
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
      };

      dev.log('NIN validation payment request body: $body', name: 'NinValidationPayout');
      
      final result = await apiService.postrequest('${transactionUrl}ninvalidation', body);
      
      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'NinValidationPayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, 
            backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          return;
        },
        (data) {
          dev.log('Payment response: $data', name: 'NinValidationPayout');
          
          final transactionId = data['data']?['transaction_id'] ?? ref;
          final formattedDate = DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
          
          dev.log('Payment successful. Transaction ID: $transactionId', name: 'NinValidationPayout');
          Get.snackbar("Success", data['message'] ?? "NIN validation request submitted successfully!", 
            backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.TRANSACTION_DETAIL_MODULE,
            arguments: {
              'name': "NIN Validation",
              'image': 'assets/images/nin_icon.png',
              'amount': double.tryParse(amount) ?? 2500.0,
              'paymentType': "NIN Validation",
              'paymentMethod': selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
              'userId': ninNumber,
              'customerName': 'N/A',
              'transactionId': transactionId,
              'packageName': 'Standard Validation',
              'token': 'Check your email within 24 hours',
              'date': formattedDate,
            },
          );
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'NinValidationPayout', error: e);
      Get.snackbar("Payment Error", "An unexpected error occurred.", 
        backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isPaying.value = false;
    }
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }
}
