import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class JambPaymentModuleController extends GetxController {
  final recipientController = TextEditingController();
  final isPaying = false.obs;
  final selectedPaymentMethod =
      'wallet'.obs; // wallet, paystack, general_market, mega_bonus

  final apiService = DioApiService();
  final box = GetStorage();

  // exam data from api
  Map<String, dynamic>? selectedExam;
  String? profileCode;
  double atmFee = 0.0;
  double walletFee = 0.0;
  double totalDue = 0.0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      selectedExam = args['selectedExam'];
      profileCode = args['profileCode'];

      _calculateFees();
    }
    dev.log('Payment screen initialized - Amount: ₦$amount',
        name: 'JambPayment');
  }

  // getters for exam data
  String get examName => selectedExam?['name'] ?? 'Unknown';
  String get variationCode => selectedExam?['variation_code'] ?? '';
  String get amount => (selectedExam?['variation_amount'] ?? 0).toString();

  void _calculateFees() {
    final baseAmount = double.tryParse(amount) ?? 0.0;
    atmFee = baseAmount * 0.015; // 1.5%
    walletFee = 0.0;
    totalDue = baseAmount + walletFee; // using wallet, so no atm fee

    dev.log(
        'Fees calculated - Base: ₦$amount, ATM: ₦$atmFee, Wallet: ₦$walletFee, Total: ₦$totalDue',
        name: 'JambPayment');
  }

  @override
  void onClose() {
    recipientController.dispose();
    super.onClose();
  }

  void setPaymentMethod(String method) {
    dev.log('Setting payment method: $method', name: 'JambPayment');
    selectedPaymentMethod.value = method;
  }

  Future<void> pay() async {
    if (recipientController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter recipient phone number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    isPaying.value = true;
    dev.log('Payment initiated', name: 'JambPayment');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found',
            name: 'JambPayment', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.",
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username_real') ?? 'JB';
      final userPrefix =
          username.length >= 2 ? username.substring(0, 2).toUpperCase() : 'JB';
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "provider": "jamb",
        "amount": amount,
        "number": recipientController.text.trim(),
        "payment": selectedPaymentMethod.value,
        "promo": "0",
        "ref": ref,
        "coded": variationCode,
      };

      dev.log(
          'Payment request body: $body with payment: ${selectedPaymentMethod.value}',
          name: 'JambPayment');
      final result =
          await apiService.postrequest('${transactionUrl}jamb', body);

      result.fold(
        (failure) {
          dev.log('Payment failed',
              name: 'JambPayment', error: failure.message);
          Get.snackbar(
            "Payment Failed",
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Payment response: $data', name: 'JambPayment');
          if (data['success'] == 1 || data.containsKey('trnx_id')) {
            dev.log('Payment successful. Transaction ID: ${data['trnx_id']}',
                name: 'JambPayment');
            Get.snackbar(
                "Success", data['message'] ?? "JAMB payment successful!",
                backgroundColor: AppColors.successBgColor,
                colorText: AppColors.textSnackbarColor);

            Get.offNamed(
              Routes.TRANSACTION_DETAIL_MODULE,
              arguments: {
                'name': "Jamb",
                'image': 'assets/images/jamb_logo.png',
                'amount': totalDue,
                'paymentType': "JAMB",
                'paymentMethod': selectedPaymentMethod.value == 'wallet'
                    ? 'MCD Balance'
                    : selectedPaymentMethod.value,
                'userId': recipientController.text,
                'transactionId': data['trnx_id']?.toString() ?? 'N/A',
                'packageName': examName,
                'billerName': 'Jamb',
                'date': DateTime.now().toString(),
                'token': data['token']?.toString() ??
                    data['data']?['token']?.toString(),
              },
            );
          } else {
            dev.log('Payment unsuccessful',
                name: 'JambPayment', error: data['message']);
            Get.snackbar("Payment Failed",
                data['message'] ?? "An unknown error occurred.",
                backgroundColor: AppColors.errorBgColor,
                colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'JambPayment', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
    } finally {
      isPaying.value = false;
    }
  }
}
