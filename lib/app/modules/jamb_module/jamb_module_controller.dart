import 'package:mcd/core/import/imports.dart';

class JambModuleController extends GetxController {
  final selectedOption = Rx<String?>(null);
  
  final options = [
    {'title': 'Direct Entry (DE) - ₦6200.00', 'price': '', 'value': 'de'},
    {'title': 'UTME PIN (with mock) - ₦7700.00', 'price': '', 'value': 'utme_with_mock'},
    {'title': 'UTME PIN (without mock) - ₦6200.00', 'price': '', 'value': 'utme_without_mock'},
  ];

  void selectOption(String value) {
    selectedOption.value = value;
  }

  void proceedToVerify() {
    if (selectedOption.value == null) {
      Get.snackbar(
        'Selection Required',
        'Please select an option to proceed',
        snackPosition: SnackPosition.TOP, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    Get.toNamed(
      Routes.JAMB_VERIFY_ACCOUNT_MODULE,
      arguments: {'selectedOption': selectedOption.value},
    );
  }
}