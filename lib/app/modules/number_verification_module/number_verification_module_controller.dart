import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class NumberVerificationModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  String? _redirectTo;

  @override
  void onInit() {
    super.onInit();
    _redirectTo = Get.arguments?['redirectTo'];
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }


  void verifyNumber() {
    if (formKey.currentState?.validate() ?? false) {
      _callValidationApi();
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
            dev.log('Network verified: $networkName', name: 'NumberVerification');
            _showConfirmationDialog(phoneController.text, networkName);
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

  void _showConfirmationDialog(String phoneNumber, String networkName) {
    Get.defaultDialog(
      title: "Confirm Network",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Is the number $phoneNumber a $networkName number?",
      textConfirm: "Confirm",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      barrierDismissible: false,
      onConfirm: () {
        Get.back(); // Close dialog
        dev.log('Number confirmed. Navigating to: $_redirectTo', name: 'NumberVerification');
        
        // Use a post frame callback to ensure dialog is fully closed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_redirectTo != null) {
            // Navigate without disposing this controller immediately
            Get.offNamed(_redirectTo!, arguments: {'verifiedNumber': phoneNumber});
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