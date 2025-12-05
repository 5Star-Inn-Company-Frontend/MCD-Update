import 'package:get/get.dart';
import 'package:mcd/core/import/imports.dart';

class VirtualCardChangePinController extends GetxController {
  final newPin = ''.obs;
  final confirmPin = ''.obs;
  final isNewPinStep = true.obs;
  
  void addDigit(String digit) {
    if (isNewPinStep.value) {
      if (newPin.value.length < 4) {
        newPin.value += digit;
        if (newPin.value.length == 4) {
          // Move to confirm step after a short delay
          Future.delayed(const Duration(milliseconds: 300), () {
            isNewPinStep.value = false;
          });
        }
      }
    } else {
      if (confirmPin.value.length < 4) {
        confirmPin.value += digit;
        if (confirmPin.value.length == 4) {
          // Validate pins match
          validatePins();
        }
      }
    }
  }
  
  void removeDigit() {
    if (isNewPinStep.value) {
      if (newPin.value.isNotEmpty) {
        newPin.value = newPin.value.substring(0, newPin.value.length - 1);
      }
    } else {
      if (confirmPin.value.isNotEmpty) {
        confirmPin.value = confirmPin.value.substring(0, confirmPin.value.length - 1);
      }
    }
  }
  
  void validatePins() {
    if (newPin.value == confirmPin.value) {
      // Pins match, proceed
      Get.back();
      Get.snackbar(
        'Success',
        'PIN changed successfully',
        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
        colorText: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      );
    } else {
      // Pins don't match, reset
      Get.snackbar(
        'Error',
        'PINs do not match. Please try again.',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
        duration: const Duration(seconds: 2),
      );
      Future.delayed(const Duration(seconds: 2), () {
        newPin.value = '';
        confirmPin.value = '';
        isNewPinStep.value = true;
      });
    }
  }
  
  void reset() {
    newPin.value = '';
    confirmPin.value = '';
    isNewPinStep.value = true;
  }
}
