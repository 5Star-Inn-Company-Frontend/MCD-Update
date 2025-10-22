import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_module/model/cable_package_model.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_page.dart';
import 'package:mcd/core/network/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class CablePayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  late final CableProvider provider;
  late final String smartCardNumber;
  late final CablePackage package;
  late final String customerName;

  final usePoints = false.obs;
  final selectedPaymentMethod = 1.obs;
  final isPaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('CablePayoutController initialized', name: 'CablePayout');
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    provider = args['provider'] ?? CableProvider(id: 0, name: 'Error', code: '');
    smartCardNumber = args['smartCardNumber'] ?? '';
    package = args['package'] ?? CablePackage(id: 0, name: '', code: '', amount: '0', duration: '1');
    customerName = args['customerName'] ?? '';
    
    dev.log('Payout details - Provider: ${provider.name}, Package: ${package.name}, Amount: ₦${package.amount}', name: 'CablePayout');
  }

  void toggleUsePoints(bool value) {
    usePoints.value = value;
    dev.log('Use points toggled: $value', name: 'CablePayout');
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'CablePayout');
    }
  }

  void confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming payment for ${package.name} - ₦${package.amount}', name: 'CablePayout');
    
    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'CablePayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.");
        return;
      }

      final ref = 'mcd_${DateTime.now().millisecondsSinceEpoch}';

      final body = {
        "coded": package.code,
        "number": smartCardNumber,
        "payment": "wallet",
        "promo": "0",
        "ref": ref,
      };

      dev.log('Payment request body: $body', name: 'CablePayout');
      final result = await apiService.postJsonRequest('$transactionUrl''tv', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'CablePayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          dev.log('Payment response: $data', name: 'CablePayout');
          if (data['success'] == 1 || data.containsKey('trnx_id')) {
            dev.log('Payment successful. Transaction ID: ${data['trnx_id']}', name: 'CablePayout');
            Get.snackbar("Success", data['message'] ?? "Cable subscription successful!", backgroundColor: Colors.green, colorText: Colors.white);

            final selectedImage = Get.find<CableModuleController>().providerImages[provider.name] ?? 
                                   Get.find<CableModuleController>().providerImages['DEFAULT']!;

            Get.off(
              () => TransactionDetailModulePage(),
              arguments: {
                'name': "${provider.name} Subscription",
                'image': selectedImage,
                'amount': double.tryParse(package.amount) ?? 0.0,
                'paymentType': "Cable TV",
                'userId': smartCardNumber,
                'customerName': customerName,
                'transactionId': data['trnx_id']?.toString() ?? ref,
                'packageName': package.name,
              },
            );
          } else {
            dev.log('Payment unsuccessful', name: 'CablePayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'CablePayout', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isPaying.value = false;
    }
  }
}