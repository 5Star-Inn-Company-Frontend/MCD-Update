import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_page.dart';
import 'package:mcd/core/network/api_service.dart';
import 'dart:developer' as dev;

class NinValidationModuleController extends GetxController {
  final apiService = Get.find<ApiService>();
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final ninController = TextEditingController();

  final isValidating = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('NinValidationModuleController initialized', name: 'NinValidation');
  }

  @override
  void onClose() {
    ninController.dispose();
    super.onClose();
  }

  Future<void> validateNin() async {
    if (ninController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a NIN number.");
      dev.log('Validation failed: NIN number missing', name: 'NinValidation', error: 'NIN missing');
      return;
    }

    if (ninController.text.length != 11) {
      Get.snackbar("Error", "Please enter a valid 11-digit NIN.");
      dev.log('Validation failed: Invalid NIN length', name: 'NinValidation', error: 'Invalid length');
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      isValidating.value = true;
      dev.log('NIN validation initiated for: ${ninController.text}', name: 'NinValidation');

      try {
        final transactionUrl = box.read('transaction_service_url');
        if (transactionUrl == null) {
          dev.log('Transaction URL not found', name: 'NinValidation', error: 'URL missing');
          Get.snackbar("Error", "Transaction URL not found.");
          return;
        }

        final ref = 'mcd_${DateTime.now().millisecondsSinceEpoch}';

        final body = {
          "number": ninController.text,
          "ref": ref,
        };

        dev.log('NIN validation request body: $body', name: 'NinValidation');
        final result = await apiService.postJsonRequest('$transactionUrl''ninvalidation', body);

        result.fold(
          (failure) {
            dev.log('NIN validation failed', name: 'NinValidation', error: failure.message);
            Get.snackbar("Validation Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
          },
          (data) {
            dev.log('NIN validation response: $data', name: 'NinValidation');
            if (data['success'] == 1 || data.containsKey('trnx_id')) {
              dev.log('NIN validation successful. Transaction ID: ${data['trnx_id']}', name: 'NinValidation');
              Get.snackbar("Success", data['message'] ?? "NIN validation request submitted successfully!", backgroundColor: Colors.green, colorText: Colors.white);

              Get.off(
                () => TransactionDetailModulePage(),
                arguments: {
                  'name': "NIN Validation",
                  'image': 'assets/images/nin_icon.png', // You'll need to add this asset
                  'amount': 2500.0,
                  'paymentType': "NIN Validation",
                  'userId': ninController.text,
                  'customerName': 'N/A',
                  'transactionId': data['trnx_id']?.toString() ?? ref,
                  'packageName': 'Standard Validation',
                },
              );
            } else {
              dev.log('NIN validation unsuccessful', name: 'NinValidation', error: data['message']);
              Get.snackbar("Validation Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
            }
          },
        );
      } catch (e) {
        dev.log("NIN validation error", name: 'NinValidation', error: e);
        Get.snackbar("Validation Error", "An unexpected client error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        isValidating.value = false;
      }
    }
  }
}