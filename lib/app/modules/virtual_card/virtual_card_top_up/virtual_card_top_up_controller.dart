import 'package:get/get.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/utils/amount_formatter.dart';

class VirtualCardTopUpController extends GetxController {
  final enteredAmount = '1200'.obs;
  final isDollar = true.obs; // true = Dollar, false = Naira
  final exchangeRate = 1500.0; // 1 USD = 1500 NGN
  final minAmount = 1.0;
  final maxAmount = 1500.0;
  
  void addDigit(String digit) {
    if (enteredAmount.value == "0") {
      enteredAmount.value = digit;
    } else {
      enteredAmount.value += digit;
    }
  }
  
  void removeDigit() {
    if (enteredAmount.value.isNotEmpty) {
      enteredAmount.value = enteredAmount.value.substring(0, enteredAmount.value.length - 1);
    }
    if (enteredAmount.value.isEmpty) {
      enteredAmount.value = "0";
    }
  }
  
  void toggleCurrency() {
    isDollar.value = !isDollar.value;
  }
  
  String get displayCurrency => isDollar.value ? "\$" : "₦";
  
  String get convertedAmount {
    final amount = double.tryParse(enteredAmount.value) ?? 0;
    if (isDollar.value) {
      // Show Naira equivalent
      final naira = amount * exchangeRate;
      return "₦${AmountUtil.formatFigure(naira)}";
    } else {
      // Show Dollar equivalent
      final dollar = amount / exchangeRate;
      return "\$${AmountUtil.formatFigure(double.parse(dollar.toStringAsFixed(2)))}";
    }
  }

  String get formattedEnteredAmount {
    final amt = double.tryParse(enteredAmount.value) ?? 0;
    return AmountUtil.formatFigure(amt);
  }
  
  void topUpCard() {
    final amount = double.tryParse(enteredAmount.value) ?? 0;
    
    if (amount < minAmount || amount > maxAmount) {
      Get.snackbar(
        'Error',
        'Amount must be between \$$minAmount and \$$maxAmount',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
      return;
    }
    
    // Navigate to payment or show success
    Get.snackbar(
      'Success',
      'Card topped up with $displayCurrency${formattedEnteredAmount} successfully',
      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
      colorText: const Color(0xFF4CAF50),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
    );
    
    // Reset and go back
    enteredAmount.value = '1200';
    Get.back();
  }
}
