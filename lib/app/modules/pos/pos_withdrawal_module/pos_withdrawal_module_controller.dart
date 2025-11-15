import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosWithdrawalModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final amountController = TextEditingController();
  final terminalId = ''.obs;
  final availableBalance = 0.0.obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosWithdrawalModuleController initialized', name: 'PosWithdrawal');
    
    // Get terminal data from arguments
    if (Get.arguments != null) {
      terminalId.value = Get.arguments['terminalId'] ?? '';
      availableBalance.value = Get.arguments['availableBalance'] ?? 0.0;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    dev.log('PosWithdrawalModuleController disposed', name: 'PosWithdrawal');
    super.onClose();
  }

  void showConfirmationDialog() {
    Get.dialog(
      _buildConfirmationDialog(),
      barrierDismissible: true,
    );
  }

  Widget _buildConfirmationDialog() {
    return const SizedBox(); // Will be implemented in the page widget
  }

  void confirmWithdrawal() {
    Get.back(); // Close dialog
    Get.toNamed('/pos_authorize_withdrawal', arguments: {
      'terminalId': terminalId.value,
      'amount': amountController.text,
    });
  }

  Future<void> processWithdrawal() async {
    try {
      isProcessing.value = true;
      
      // TODO: Replace with actual API endpoint
      // final response = await apiService.post('/pos/withdrawal', data: {...});
      
      await Future.delayed(const Duration(seconds: 2));
      
      isProcessing.value = false;
      
      Get.snackbar(
        'Success',
        'Withdrawal processed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      Get.back();
    } catch (e) {
      isProcessing.value = false;
      dev.log('Error processing withdrawal: $e', name: 'PosWithdrawal');
      Get.snackbar(
        'Error',
        'Failed to process withdrawal',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
