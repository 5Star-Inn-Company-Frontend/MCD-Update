import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'dart:developer' as dev;

class CardTopupModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  // For amount input screen
  final enteredAmount = ''.obs;
  final isProcessing = false.obs;
  
  // For card details screen
  final formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final amountController = TextEditingController();
  
  final isLoading = false.obs;
  final cardType = ''.obs; // visa, mastercard, verve, etc.
  
  String get paystackPublicKey => box.read('paystack_public_key') ?? 'pk_live_bf9ad0c818ede7986e1f93198a1eb02eef57c7d9'; // Fallback key
  String get paystackSecretKey => 'sk_live_f1287e078d04cc1049db9bbb46ea9395db795a9c'; // Fallback key
  
  @override
  void onInit() {
    super.onInit();
    dev.log('CardTopupModuleController initialized', name: 'CardTopup');
    
    // Add listener to card number for card type detection
    cardNumberController.addListener(_detectCardType);
  }
  
  @override
  void onClose() {
    cardNumberController.dispose();
    cardNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    amountController.dispose();
    super.onClose();
  }
  
  // Amount input methods
  void addDigit(String digit) {
    if (enteredAmount.value.length < 10) { // Max 10 digits
      enteredAmount.value += digit;
    }
  }
  
  void deleteDigit() {
    if (enteredAmount.value.isNotEmpty) {
      enteredAmount.value = enteredAmount.value.substring(0, enteredAmount.value.length - 1);
    }
  }
  
  String get formattedAmount {
    if (enteredAmount.value.isEmpty) return '0.00';
    final amount = int.parse(enteredAmount.value);
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
  
  void showConfirmationBottomSheet() {
    if (enteredAmount.value.isEmpty || int.parse(enteredAmount.value) <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 32,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Confirm Wallet Top-up',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.manRope,
                color: AppColors.background,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              'Are you sure you want to fund your wallet with the sum of ₦${formattedAmount}?',
              style: GoogleFonts.arimo(
                fontSize: 15,
                color: AppColors.background.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Pay with Paystack Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  initiatePaystackPayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pay with Paystack',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.manRope,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.manRope,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
  
  Future<void> initiatePaystackPayment() async {
    try {
      isProcessing.value = true;
      Get.back(); // Close the dialog first
      
      final reference = PayWithPayStack().generateUuidV4();
      final amount = int.parse(enteredAmount.value);
      
      dev.log('Initiating Paystack payment for ₦$amount with reference: $reference', name: 'CardTopup');
      
      // Get user email
      final userEmail = box.read('user_email') ?? 'user@mcd.com';
      
      // Log transaction to backend
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        isProcessing.value = false;
        Get.snackbar(
          'Error',
          'Service configuration error. Please login again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      
      // Log to backend
      final fundBody = {
        'amount': enteredAmount.value,
        'ref': reference,
        'medium': 'paystack',
      };
      
      await apiService.postrequest('${transactionUrl}fundwallet', fundBody);
      
      isProcessing.value = false;
      
      dev.log('Charging card with Paystack...', name: 'CardTopup');
      
      // Charge the card using pay_with_paystack
      PayWithPayStack().now(
        context: Get.context!,
        secretKey: paystackSecretKey,
        customerEmail: userEmail,
        reference: reference,
        currency: "NGN",
        amount: amount * 100, // Convert to kobo
        callbackUrl: "https://standard.paystack.co/close",
        transactionCompleted: (paymentData) {
          dev.log('Paystack payment completed: $paymentData', name: 'CardTopup');
          
          Get.snackbar(
            'Payment Successful',
            'Your wallet will be credited shortly.',
            backgroundColor: AppColors.successBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 4),
          );
          
          enteredAmount.value = '';
          Get.until((route) => route.settings.name == Routes.HOME_SCREEN);
        },
        transactionNotCompleted: (reason) {
          dev.log('Paystack payment failed: $reason', name: 'CardTopup');
          
          Get.snackbar(
            'Payment Failed',
            reason,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
      );
      
    } catch (e) {
      isProcessing.value = false;
      dev.log('Error processing Paystack payment', name: 'CardTopup', error: e);
      Get.snackbar(
        'Error',
        'Failed to process payment: ${e.toString()}',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    }
  }
  
  void _detectCardType() {
    final number = cardNumberController.text.replaceAll(' ', '');
    if (number.isEmpty) {
      cardType.value = '';
      return;
    }
    
    // Visa: starts with 4
    if (number.startsWith('4')) {
      cardType.value = 'visa';
    }
    // Mastercard: starts with 51-55 or 2221-2720
    else if (number.startsWith(RegExp(r'^5[1-5]')) || 
             number.startsWith(RegExp(r'^2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[0-1][0-9]|720)'))) {
      cardType.value = 'mastercard';
    }
    // Verve: starts with 506 or 650
    else if (number.startsWith('506') || number.startsWith('650')) {
      cardType.value = 'verve';
    }
    else {
      cardType.value = '';
    }
  }
  
  String formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }
  
  String formatExpiryDate(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }
  
  Future<void> processTopup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      dev.log('Processing card top-up', name: 'CardTopup');
      
      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null) {
        dev.log('Utility URL not found', name: 'CardTopup', error: 'URL missing');
        Get.snackbar(
          'Error',
          'Service configuration error. Please login again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      
      final body = {
        'card_number': cardNumberController.text.replaceAll(' ', ''),
        'card_name': cardNameController.text,
        'expiry_date': expiryDateController.text,
        'cvv': cvvController.text,
        'amount': amountController.text,
      };
      
      dev.log('Sending card top-up request', name: 'CardTopup');
      
      final result = await apiService.postrequest('${utilityUrl}card-topup', body);
      
      result.fold(
        (failure) {
          dev.log('Card top-up failed', name: 'CardTopup', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            dev.log('Card top-up successful', name: 'CardTopup');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Top-up successful',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            
            // Clear form
            _clearForm();
            
            // Navigate back or to success page
            Get.back();
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Top-up failed',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error processing card top-up', name: 'CardTopup', error: e);
      Get.snackbar(
        'Error',
        'An error occurred while processing your request',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void _clearForm() {
    cardNumberController.clear();
    cardNameController.clear();
    expiryDateController.clear();
    cvvController.clear();
    amountController.clear();
    cardType.value = '';
  }
}
