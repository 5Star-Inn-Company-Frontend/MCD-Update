import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class DataPinPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final String networkName;
  final String networkCode;
  final String networkImage;
  final String designType;
  final String quantity;
  final String amount;
  final String recipient;
  final String coded;

  DataPinPayoutController({
    required this.networkName,
    required this.networkCode,
    required this.networkImage,
    required this.designType,
    required this.quantity,
    required this.amount,
    required this.recipient,
    required this.coded,
  });

  final TextEditingController promoCodeController = TextEditingController();

  final isPaying = false.obs;
  final selectedPaymentMethod = 1.obs;
  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('DataPinPayoutController initialized', name: 'DataPinPayout');
    _fetchBalances();
  }

  Future<void> _fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'DataPinPayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'DataPinPayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'DataPinPayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'DataPinPayout', error: e);
    }
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'DataPinPayout');
    }
  }

  void clearPromoCode() {
    promoCodeController.clear();
  }

  Future<void> confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming Data Pin payment', name: 'DataPinPayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'DataPinPayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", 
          backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'mcd_${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "coded": coded,
        "number": recipient,
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
        "ref": ref,
        "country": "NG",
        "quantity": quantity,
      };

      dev.log('Data Pin payment request body: $body', name: 'DataPinPayout');
      final result = await apiService.postrequest('${transactionUrl}datapin', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'DataPinPayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, 
            backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          dev.log('Payment response: $data', name: 'DataPinPayout');
          if (data['success'] == 1 || data['success'] == true) {
            final transactionId = data['ref'] ?? data['trnx_id'] ?? ref;
            final debitAmount = data['debitAmount'] ?? data['amount'] ?? amount;
            final transactionDate = data['date'] ?? data['created_at'] ?? data['timestamp'];
            final token = data['token'] ?? 'N/A';
            final formattedDate = transactionDate != null 
                ? transactionDate.toString() 
                : DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
            
            dev.log('Payment successful. Transaction ID: $transactionId', name: 'DataPinPayout');
            Get.snackbar("Success", data['message'] ?? "Data Pin purchase successful!", 
              backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);

            Get.offNamed(
              Routes.EPIN_TRANSACTION_DETAIL,
              arguments: {
                'networkName': networkName,
                'networkImage': networkImage,
                'amount': debitAmount.toString(),
                'designType': designType,
                'quantity': quantity,
                'paymentMethod': selectedPaymentMethod.value == 1 ? 'MCD Balance' : 'Mega Bonus',
                'transactionId': transactionId,
                'postedDate': formattedDate,
                'transactionDate': formattedDate,
                'token': token,
              },
            );
          } else {
            dev.log('Payment unsuccessful', name: 'DataPinPayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", 
              backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'DataPinPayout', error: e);
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
