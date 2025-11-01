import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/import/imports.dart';
import '../../../core/network/dio_api_service.dart';

class NumberVerificationModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final isLoading = false.obs;
  
  String? _redirectTo;

  @override
  void onInit() {
    super.onInit();
    // Get the redirect route from navigation arguments
    _redirectTo = Get.arguments?['redirectTo'];
    dev.log('NumberVerificationModule initialized with redirectTo: $_redirectTo', name: 'NumberVerification');
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> verifyNumber() async {
    if (formKey.currentState?.validate() ?? false) {
      await _callValidationApi();
    }
  }

  Future<void> _callValidationApi() async {
    isLoading.value = true;
    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        Get.snackbar("Error", "Transaction URL not found. Please log in again.");
        return;
      }

      final serviceName = (_redirectTo?.contains('data') ?? false) ? 'data' : 'airtime';

      final body = {
        "service": serviceName,
        "provider": "Ng",
        "number": phoneController.text,
      };

      dev.log('Validation request body: $body', name: 'NumberVerification');
      final result = await apiService.postJsonRequest('$transactionUrl''validate-number', body);

      result.fold(
        (failure) {
          dev.log('Verification Failed: ${failure.message}', name: 'NumberVerification');
          Get.snackbar("Verification Failed", failure.message,
              backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          dev.log('Verification response: $data', name: 'NumberVerification');
          if (data['success'] == 1) {
            final networkName = data['data']?['operatorName'] ?? 'Unknown Network';
            final networkData = data['data'] ?? {};
            dev.log('✅ Network verified: "$networkName" (Full data: $networkData)', name: 'NumberVerification');
            _showConfirmationDialog(phoneController.text, networkName, networkData);
          } else {
            dev.log("Verification Failed: ${data['message']}", name: 'NumberVerification');
            Get.snackbar("Verification Failed", data['message'] ?? "Could not verify number.",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showConfirmationDialog(String phoneNumber, String networkName, Map<String, dynamic> networkData) {
    Get.defaultDialog(
      title: "Confirm Network",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppFonts.manRope,),
      middleText: "Is the number $phoneNumber a $networkName number?",
      middleTextStyle: const TextStyle(fontFamily: AppFonts.manRope,),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      barrierDismissible: false,
      contentPadding: EdgeInsets.all(20),
      radius: 12,
      onConfirm: () {
        Get.back(); // Close dialog
        dev.log('Number confirmed. Navigating to: $_redirectTo with network: $networkName', name: 'NumberVerification');
        
        // Use a post frame callback to ensure dialog is fully closed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_redirectTo != null) {
            // Navigate without disposing this controller immediately
            // Pass both verified number and network information
            Get.offNamed(_redirectTo!, arguments: {
              'verifiedNumber': phoneNumber,
              'verifiedNetwork': networkName,
              'networkData': networkData,
            });
          } else {
            Get.snackbar("Success", "Number verified!");
            Get.back();
          }
        });
      },
      onCancel: () {
        dev.log('User cancelled confirmation', name: 'NumberVerification');
      },
    );
  }
}
