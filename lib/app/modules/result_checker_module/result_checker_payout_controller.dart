import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class ResultCheckerPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final String examName;
  final String examLogo;
  final String examCode;
  final String quantity;
  final String amount;

  ResultCheckerPayoutController({
    required this.examName,
    required this.examLogo,
    required this.examCode,
    required this.quantity,
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
    dev.log('ResultCheckerPayoutController initialized', name: 'ResultCheckerPayout');
    _fetchBalances();
  }

  Future<void> _fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'ResultCheckerPayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'ResultCheckerPayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'ResultCheckerPayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'ResultCheckerPayout', error: e);
    }
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'ResultCheckerPayout');
    }
  }

  void clearPromoCode() {
    promoCodeController.clear();
  }

  Future<void> confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming Result Checker payment', name: 'ResultCheckerPayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'ResultCheckerPayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", 
          backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'mcd_${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "coded": examCode.toUpperCase(),
        "quantity": quantity,
        "ref": ref,
        "number": "0",
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
      };

      dev.log('Result Checker payment request body: $body', name: 'ResultCheckerPayout');
      
      final result = await apiService.postrequest('${transactionUrl}resultchecker', body);
      
      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'ResultCheckerPayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, 
            backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          return;
        },
        (data) {
          dev.log('Payment response: $data', name: 'ResultCheckerPayout');
          
          final transactionId = data['data']?['transaction_id'] ?? ref;
          final token = data['data']?['token'] ?? 'Check your email';
          final formattedDate = DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
          
          dev.log('Payment successful. Transaction ID: $transactionId', name: 'ResultCheckerPayout');
          Get.snackbar("Success", data['message'] ?? "Result Checker purchase successful! Check your email.", 
            backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.TRANSACTION_DETAIL_MODULE,
            arguments: {
              'name': "Result Checker Token",
              'image': examLogo,
              'amount': double.tryParse(amount) ?? 0.0,
              'paymentType': "Wallet",
              'paymentMethod': selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
              'userId': 'N/A',
              'customerName': examName,
              'transactionId': transactionId,
              'packageName': examName,
              'token': token,
              'date': formattedDate,
            },
          );
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'ResultCheckerPayout', error: e);
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
