import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/home_screen_module/home_screen_controller.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class AirtimePinPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final promoCodeController = TextEditingController();
  final isPaying = false.obs;
  
  // Payment arguments from previous screen
  late String networkName;
  late String networkCode;
  late String networkImage;
  late String amount;
  late String quantity;
  late String recipient;
  
  final selectedPaymentMethod = 'wallet'.obs;
  final walletBalance = '0.00'.obs;
  final bonusBalance = '0.00'.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _fetchBalances();
  }
  
  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    networkName = args['networkName'] ?? '';
    networkCode = args['networkCode'] ?? '';
    networkImage = args['networkImage'] ?? '';
    amount = args['amount'] ?? '';
    quantity = args['quantity'] ?? '1';
    recipient = args['recipient'] ?? '';
    
    dev.log('Airtime Pin Payout initialized with: Network=$networkName, Amount=$amount, Qty=$quantity', name: 'AirtimePinPayout');
  }
  
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
  
  void clearPromoCode() {
    promoCodeController.clear();
  }
  
  void _fetchBalances() {
    try {
      final homeController = Get.find<HomeScreenController>();
      if (homeController.dashboardData != null) {
        walletBalance.value = homeController.dashboardData.balance.wallet;
        bonusBalance.value = homeController.dashboardData.balance.bonus;
        dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'AirtimePinPayout');
      }
    } catch (e) {
      dev.log('Error fetching balances: $e', name: 'AirtimePinPayout');
    }
  }
  
  Future<void> confirmAndPay() async {
    if (networkCode.isEmpty || amount.isEmpty || recipient.isEmpty) {
      Get.snackbar(
        "Error",
        "Missing required information",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    isPaying.value = true;
    dev.log('Processing Airtime Pin payment...', name: 'AirtimePinPayout');
    
    try {
      final transactionUrl = box.read('transaction_service_url') ?? '';
      
      if (transactionUrl.isEmpty) {
        Get.snackbar(
          "Error",
          "Transaction URL not found. Please log in again.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        isPaying.value = false;
        return;
      }

      // Generate reference
      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';
      
      final body = {
        'provider': networkCode.toUpperCase(),
        'amount': amount,
        'number': recipient,
        'quantity': quantity,
        'payment': selectedPaymentMethod.value,
        'promo': promoCodeController.text.isNotEmpty ? promoCodeController.text : '0',
        'ref': ref,
      };

      dev.log('Airtime Pin request body: $body', name: 'AirtimePinPayout');

      final response = await apiService.postrequest(
        "${transactionUrl}airtimepin",
        body,
      );

      response.fold(
        (failure) {
          dev.log('Airtime Pin payment failed: ${failure.message}', name: 'AirtimePinPayout');
          Get.snackbar(
            "Payment Failed",
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Airtime Pin payment response: $data', name: 'AirtimePinPayout');
          
          if (data['success'] == 1) {
            final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
            final debitAmount = data['debitAmount'] ?? data['amount'] ?? amount;
            final transactionDate = data['date'] ?? data['created_at'] ?? data['timestamp'];
            final token = data['token'] ?? 'N/A';
            final formattedDate = transactionDate != null 
                ? transactionDate.toString() 
                : DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
            
            dev.log('Airtime Pin payment successful. Transaction ID: $transactionId', name: 'AirtimePinPayout');
            Get.snackbar(
              "Success",
              data['message'] ?? "Airtime Pin purchase successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );

            // Navigate to E-pin transaction detail
            Get.offNamed(
              Routes.EPIN_TRANSACTION_DETAIL,
              arguments: {
                'networkName': networkName,
                'networkImage': networkImage,
                'amount': debitAmount.toString(),
                'designType': '2',
                'quantity': quantity,
                'paymentMethod': selectedPaymentMethod.value == 'wallet' ? 'MCD Balance' : 'Mega Bonus',
                'transactionId': transactionId,
                'postedDate': formattedDate,
                'transactionDate': formattedDate,
                'token': token,
              },
            );
          } else {
            Get.snackbar(
              "Payment Failed",
              data['message'] ?? "Airtime Pin purchase failed. Please try again.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error processing Airtime Pin payment: $e', name: 'AirtimePinPayout');
      Get.snackbar(
        "Error",
        "An error occurred. Please try again.",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
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
