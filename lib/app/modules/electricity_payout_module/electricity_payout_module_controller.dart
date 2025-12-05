import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/electricity_module/electricity_module_controller.dart';
import 'package:mcd/app/modules/electricity_module/model/electricity_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class ElectricityPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  // --- STATE FROM ARGUMENTS ---
  late final ElectricityProvider provider;
  late final String meterNumber;
  late final double amount;
  late final String paymentType;
  late final String customerName;

  // --- UI STATE ---
  final usePoints = false.obs;
  final selectedPaymentMethod = 1.obs; // 1 for Wallet, 2 for Bonus
  final isPaying = false.obs;
  final promoCodeController = TextEditingController();
  
  // --- BALANCE STATE ---
  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;
  final pointsBalance = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('ElectricityPayoutController initialized', name: 'ElectricityPayout');
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    provider = args['provider'] ?? ElectricityProvider(id: 0, name: 'Error', code: '');
    meterNumber = args['meterNumber'] ?? '';
    amount = args['amount'] ?? 0.0;
    paymentType = args['paymentType'] ?? '';
    customerName = args['customerName'] ?? '';

    dev.log('Payout details - Provider: ${provider.name}, Amount: ₦$amount, Type: $paymentType', name: 'ElectricityPayout');
    fetchBalances();
  }
  
  Future<void> fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'ElectricityPayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'ElectricityPayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            pointsBalance.value = data['data']['balance']['points']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'ElectricityPayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'ElectricityPayout', error: e);
    }
  }

  void toggleUsePoints(bool value) {
    usePoints.value = value;
    dev.log('Use points toggled: $value', name: 'ElectricityPayout');
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'ElectricityPayout');
    }
  }

  void clearPromoCode() {
    promoCodeController.clear();
    dev.log('Promo code cleared', name: 'ElectricityPayout');
  }

  void confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming payment for ₦$amount', name: 'ElectricityPayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'ElectricityPayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.");
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "provider": provider.code.toLowerCase(),
        "number": meterNumber,
        "amount": amount.toString(),
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": promoCodeController.text.trim().isEmpty ? "0" : promoCodeController.text.trim(),
        "ref": ref,
      };

      dev.log('Payment request body: $body', name: 'ElectricityPayout');
      final result = await apiService.postrequest('$transactionUrl/electricity', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'ElectricityPayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          dev.log('Payment response: $data', name: 'ElectricityPayout');
          if (data['success'] == 1 || data.containsKey('trnx_id')) {
            // Extract token for prepaid electricity
            String token = 'N/A';
            if (paymentType.toLowerCase() == 'prepaid') {
              token = data['token']?.toString() ?? 
                      data['data']?['token']?.toString() ?? 
                      data['Token']?.toString() ??
                      data['data']?['Token']?.toString() ?? 
                      'N/A';
              dev.log('Token extracted for prepaid: $token', name: 'ElectricityPayout');
            }
            
            final transactionDate = data['date'] ?? data['created_at'] ?? data['timestamp'];
            final formattedDate = transactionDate != null 
                ? transactionDate.toString() 
                : DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
            
            dev.log('Payment successful. Transaction ID: ${data['trnx_id']}, Token: $token', name: 'ElectricityPayout');
            Get.snackbar("Success", data['message'] ?? "Electricity payment successful!", backgroundColor: Colors.green, colorText: Colors.white);

            final selectedImage = Get.find<ElectricityModuleController>().providerImages[provider.name] ?? 
                                   Get.find<ElectricityModuleController>().providerImages['DEFAULT']!;

            Get.offNamed(
              Routes.TRANSACTION_DETAIL_MODULE,
              arguments: {
                'name': "${provider.name} - $paymentType",
                'image': selectedImage,
                'amount': amount,
                'paymentType': "Electricity",
                'paymentMethod': selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
                'userId': meterNumber,
                'customerName': customerName,
                'transactionId': data['trnx_id']?.toString() ?? ref,
                'packageName': paymentType,
                'token': token,
                'date': formattedDate,
              },
            );
          } else {
            dev.log('Payment unsuccessful', name: 'ElectricityPayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'ElectricityPayout', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
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