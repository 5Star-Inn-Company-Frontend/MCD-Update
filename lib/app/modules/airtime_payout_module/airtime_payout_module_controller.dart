import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/airtime_module/model/airtime_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class AirtimePayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  late final AirtimeProvider? provider;
  late final String? phoneNumber;
  late final String? amount;
  late final String? networkImage;
  
  // Multiple airtime
  late final bool isMultiple;
  late final List<Map<String, dynamic>>? multipleList;

  final selectedPaymentMethod = 1.obs;
  final isPaying = false.obs;
  
  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('AirtimePayoutController initialized', name: 'AirtimePayout');
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    
    isMultiple = args['isMultiple'] ?? false;
    
    if (isMultiple) {
      multipleList = args['multipleList'] ?? [];
      dev.log('Multiple airtime payout with ${multipleList?.length ?? 0} numbers', name: 'AirtimePayout');
    } else {
      provider = args['provider'] ?? AirtimeProvider(network: 'Error', server: '0', discount: '0', status: 0);
      phoneNumber = args['phoneNumber'] ?? '';
      amount = args['amount'] ?? '0';
      networkImage = args['networkImage'] ?? '';
      dev.log('Single airtime payout - Provider: ${provider?.network}, Amount: ₦$amount, Phone: $phoneNumber', name: 'AirtimePayout');
    }

    fetchBalances();
  }
  
  Future<void> fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'AirtimePayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'AirtimePayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'AirtimePayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'AirtimePayout', error: e);
    }
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'AirtimePayout');
    }
  }

  void confirmAndPay() async {
    if (isMultiple) {
      await _payMultipleAirtime();
    } else {
      await _paySingleAirtime();
    }
  }
  
  Future<void> _paySingleAirtime() async {
    isPaying.value = true;
    dev.log('Confirming single payment for ₦$amount', name: 'AirtimePayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'AirtimePayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "provider": provider!.network.toUpperCase(),
        "amount": amount.toString(),
        "number": phoneNumber,
        "country": "NG",
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": "0",
        "ref": ref,
        "operatorID": int.tryParse(provider!.server) ?? 0,
      };

      dev.log('Payment request body: $body with payment: ${selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus"}', name: 'AirtimePayout');
      final result = await apiService.postrequest('${transactionUrl}airtime', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'AirtimePayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          dev.log('Payment response: $data', name: 'AirtimePayout');
          if (data['success'] == 1) {
            final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
            final debitAmount = data['debitAmount'] ?? data['amount'] ?? amount;
            final transactionDate = data['date'] ?? data['created_at'] ?? data['timestamp'];
            final formattedDate = transactionDate != null 
                ? transactionDate.toString() 
                : DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
            
            dev.log('Payment successful. Transaction ID: $transactionId', name: 'AirtimePayout');
            Get.snackbar("Success", data['message'] ?? "Airtime purchase successful!", backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);

            Get.offNamed(
              Routes.TRANSACTION_DETAIL_MODULE,
              arguments: {
                'name': "Airtime Top Up",
                'image': networkImage,
                'amount': double.tryParse(debitAmount.toString()) ?? 0.0,
                'paymentType': "Wallet",
                'paymentMethod': selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
                'userId': phoneNumber,
                'customerName': provider!.network.toUpperCase(),
                'transactionId': transactionId,
                'packageName': '${provider!.network} Airtime',
                'token': 'N/A',
                'date': formattedDate,
              },
            );
          } else {
            dev.log('Payment unsuccessful', name: 'AirtimePayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'AirtimePayout', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isPaying.value = false;
    }
  }
  
  Future<void> _payMultipleAirtime() async {
    if (multipleList == null || multipleList!.isEmpty) {
      Get.snackbar("Error", "No numbers to process.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    isPaying.value = true;
    dev.log('Processing multiple airtime for ${multipleList!.length} numbers', name: 'AirtimePayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'AirtimePayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';
      
      // Build data array for all recipients
      final dataArray = multipleList!.map((item) {
        final provider = item['provider'] as AirtimeProvider;
        final phoneNumber = item['phoneNumber'];
        final amount = item['amount'];
        
        return {
          "provider": provider.network.toUpperCase(),
          "amount": amount.toString(),
          "number": phoneNumber,
          "operatorID": int.tryParse(provider.server) ?? 0,
        };
      }).toList();
      
      final body = {
        "country": "NG",
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": "0",
        "ref": ref,
        "data": dataArray,
      };

      dev.log('Multiple airtime request body: $body', name: 'AirtimePayout');
      final result = await apiService.postrequest('${transactionUrl}airtime', body);

      result.fold(
        (failure) {
          dev.log('Multiple airtime payment failed', name: 'AirtimePayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          dev.log('Multiple airtime response: $data', name: 'AirtimePayout');
          if (data['success'] == 1) {
            dev.log('Multiple airtime payment successful', name: 'AirtimePayout');
            Get.snackbar(
              "Success",
              data['message'] ?? "${multipleList!.length} airtime purchase(s) completed successfully!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 4),
            );
            
            // Navigate back to home
            Future.delayed(const Duration(seconds: 2), () {
              Get.offAllNamed(Routes.HOME_SCREEN);
            });
          } else {
            dev.log('Multiple airtime payment unsuccessful', name: 'AirtimePayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      dev.log("Multiple Payment Error", name: 'AirtimePayout', error: e);
      Get.snackbar("Payment Error", "An unexpected error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isPaying.value = false;
    }
  }
}
