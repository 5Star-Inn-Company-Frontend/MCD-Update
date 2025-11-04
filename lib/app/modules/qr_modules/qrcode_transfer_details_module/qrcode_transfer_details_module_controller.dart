import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';

class QrcodeTransferDetailsModuleController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Text editing controller
  final amountController = TextEditingController();

  // Scanned user data
  final _scannedUsername = ''.obs;
  String get scannedUsername => _scannedUsername.value;

  final _scannedEmail = ''.obs;
  String get scannedEmail => _scannedEmail.value;

  final _currentWallet = 0.0.obs;
  double get currentWallet => _currentWallet.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Load current wallet balance
    _currentWallet.value = _storage.read('wallet_balance') ?? 100.0;
    
    // Load scanned user data from arguments
    final args = Get.arguments;
    if (args != null) {
      _scannedUsername.value = args['username'] ?? 'Tesd';
      _scannedEmail.value = args['email'] ?? 'admin@5starcompany.com.ng';
    } else {
      // Default values for testing
      _scannedUsername.value = 'Tesd';
      _scannedEmail.value = 'admin@5starcompany.com.ng';
    }
  }

  Future<void> transfer() async {
    if (!formKey.currentState!.validate()) return;

    try {
      _isLoading.value = true;

      final amount = double.tryParse(amountController.text) ?? 0.0;

      if (amount <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid amount',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      if (amount > currentWallet) {
        Get.snackbar(
          'Error',
          'Insufficient balance',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      // TODO: Implement actual transfer API call here
      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      Get.snackbar(
        'Success',
        'Transfer successful',
        backgroundColor: AppColors.successBgColor,
        colorText: AppColors.textSnackbarColor,
      );

      // Navigate back or to success screen
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Transfer failed: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
