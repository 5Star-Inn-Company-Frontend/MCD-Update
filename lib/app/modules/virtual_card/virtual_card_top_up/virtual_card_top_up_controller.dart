import 'package:get/get.dart';
import 'package:mcd/core/import/imports.dart';

class VirtualCardTopUpController extends GetxController {
  final enteredAmount = ''.obs;
  final minAmount = 1.0;
  final maxAmount = 1500.0;
  
  void addDigit(String digit) {
    if (enteredAmount.value.length < 6) {
      enteredAmount.value += digit;
    }
  }
  
  void removeDigit() {
    if (enteredAmount.value.isNotEmpty) {
      enteredAmount.value = enteredAmount.value.substring(0, enteredAmount.value.length - 1);
    }
  }
  
  void topUpCard() {
    final amount = double.tryParse(enteredAmount.value) ?? 0;
    
    if (amount < minAmount || amount > maxAmount) {
      Get.snackbar(
        'Error',
        'Amount must be between \$$minAmount and \$$maxAmount',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
      );
      return;
    }
    
    // Navigate to payment or show success
    Get.snackbar(
      'Success',
      'Card topped up with \$${enteredAmount.value} successfully',
      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
      colorText: const Color(0xFF4CAF50),
    );
    
    // Reset and go back
    enteredAmount.value = '';
    Get.back();
  }
}
