import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';  
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_page.dart';
import 'dart:developer' as dev;

class JambPaymentModuleController extends GetxController {
  final recipientController = TextEditingController();
  final isPaying = false.obs;
  
  final apiService = DioApiService();
  final box = GetStorage();
  
  String? selectedOption;
  String? selectedOptionTitle;
  String? profileCode;
  String? amount;
  double atmFee = 0.0;
  double walletFee = 0.0;
  double totalDue = 0.0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      selectedOption = args['selectedOption'];
      selectedOptionTitle = args['selectedOptionTitle'];
      profileCode = args['profileCode'];
      amount = args['amount'];
      
      _calculateFees();
    }
    dev.log('Payment screen initialized - Amount: ₦$amount', name: 'JambPayment');
  }

  void _calculateFees() {
    final baseAmount = double.tryParse(amount ?? '0') ?? 0.0;
    atmFee = baseAmount * 0.015; // 1.5%
    walletFee = 0.0;
    totalDue = baseAmount + walletFee; // Using wallet, so no ATM fee
    
    dev.log('Fees calculated - Base: ₦$baseAmount, ATM: ₦$atmFee, Wallet: ₦$walletFee, Total: ₦$totalDue', name: 'JambPayment');
  }

  @override
  void onClose() {
    recipientController.dispose();
    super.onClose();
  }

  String _getCodedValue() {
    switch (selectedOption) {
      case 'de':
        return 'de';
      case 'utme_with_mock':
        return 'utme';
      case 'utme_without_mock':
        return 'utme';
      default:
        return 'utme';
    }
  }

  Future<void> pay() async {
    if (recipientController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter recipient phone number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isPaying.value = true;
    dev.log('Payment initiated', name: 'JambPayment');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'JambPayment', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.");
        return;
      }

      final ref = 'mcd_${DateTime.now().millisecondsSinceEpoch}';

      final body = {
        "provider": "jamb",
        "amount": amount,
        "number": recipientController.text.trim(),
        "payment": "wallet",
        "promo": "0",
        "ref": ref,
        "coded": _getCodedValue(),
      };

      dev.log('Payment request body: $body', name: 'JambPayment');
      final result = await apiService.postJsonRequest('${transactionUrl}jamb', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'JambPayment', error: failure.message);
          Get.snackbar(
            "Payment Failed", 
            failure.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (data) {
          dev.log('Payment response: $data', name: 'JambPayment');
          if (data['success'] == 1 || data.containsKey('trnx_id')) {
            dev.log('Payment successful. Transaction ID: ${data['trnx_id']}', name: 'JambPayment');
            Get.snackbar("Success", data['message'] ?? "JAMB payment successful!");

            Get.off(
              () => TransactionDetailModulePage(),
              arguments: {
                'name': "JAMB Pin Purchase",
                'image': 'assets/images/jamb_logo.png', // Add JAMB logo to assets
                'amount': totalDue,
                'paymentType': "JAMB",
                'userId': recipientController.text,
                'transactionId': data['trnx_id']?.toString() ?? 'N/A',
                'packageName': selectedOptionTitle ?? 'N/A',
              },
            );
          } else {
            dev.log('Payment unsuccessful', name: 'JambPayment', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.");
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'JambPayment', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.");
    } finally {
      isPaying.value = false;
    }
  }
}
