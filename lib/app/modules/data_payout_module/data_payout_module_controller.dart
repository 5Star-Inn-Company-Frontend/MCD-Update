import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/data_module/model/data_plan_model.dart';
import 'package:mcd/app/modules/data_module/network_provider.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class DataPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();


  late final NetworkProvider networkProvider;
  late final DataPlanModel dataPlan;
  late final String phoneNumber;
  late final String networkImage;


  final selectedPaymentMethod = 1.obs;
  final isPaying = false.obs;
  

  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('DataPayoutController initialized', name: 'DataPayout');
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    networkProvider = args['networkProvider'] ?? NetworkProvider(name: 'Error', imageAsset: '');
    dataPlan = args['dataPlan'] ?? DataPlanModel(id: 0, name: 'Error', price: '0', network: 'Error', category: 'Error', coded: '0');
    phoneNumber = args['phoneNumber'] ?? '';
    networkImage = args['networkImage'] ?? '';

    dev.log('Payout details - Provider: ${networkProvider.name}, Plan: ${dataPlan.name}, Phone: $phoneNumber', name: 'DataPayout');
    fetchBalances();
  }
  
  Future<void> fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'DataPayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'DataPayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'DataPayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'DataPayout', error: e);
    }
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'DataPayout');
    }
  }

  void confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming payment for ${dataPlan.name}', name: 'DataPayout');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'DataPayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "coded": dataPlan.coded,
        "number": phoneNumber,
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": "0",
        "ref": ref,
        "country": "NG"
      };

      dev.log('Payment request body: $body with payment: ${selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus"}', name: 'DataPayout');
      final result = await apiService.postrequest('$transactionUrl''data', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'DataPayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          dev.log('Payment response: $data', name: 'DataPayout');
          if (data['success'] == 1) {
            final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
            final debitAmount = data['debitAmount'] ?? data['amount'] ?? dataPlan.price;
            final transactionDate = data['date'] ?? data['created_at'] ?? data['timestamp'];
            final formattedDate = transactionDate != null 
                ? transactionDate.toString() 
                : DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
            
            dev.log('Payment successful. Transaction ID: $transactionId', name: 'DataPayout');
            Get.snackbar("Success", data['message'] ?? "Data purchase successful!", backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
            
            Get.offNamed(Routes.TRANSACTION_DETAIL_MODULE, arguments: {
              'name': dataPlan.name,
              'image': networkImage,
              'amount': double.tryParse(debitAmount.toString()) ?? 0.0,
              'paymentType': 'Wallet',
              'paymentMethod': selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
              'userId': phoneNumber,
              'customerName': networkProvider.name,
              'transactionId': transactionId,
              'packageName': dataPlan.name,
              'token': 'N/A',
              'date': formattedDate,
            });
          } else {
            dev.log('Payment unsuccessful', name: 'DataPayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'DataPayout', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isPaying.value = false;
    }
  }
}
