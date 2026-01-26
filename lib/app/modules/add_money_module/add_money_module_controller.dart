import 'package:flutter/services.dart';
import 'package:mcd/app/modules/home_screen_module/model/dashboard_model.dart';
import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

class AddMoneyModuleController extends GetxController {
  final dashboardData = Rxn<DashboardModel>();

  @override
  void onInit() {
    super.onInit();
    dev.log('AddMoneyModuleController initialized', name: 'AddMoney');

    // Get dashboard data from arguments if passed
    final data = Get.arguments?['dashboardData'];
    if (data != null && data is DashboardModel) {
      dashboardData.value = data;
      dev.log('Dashboard data loaded from arguments', name: 'AddMoney');
    }
  }

  Future<void> copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    dev.log('$label copied to clipboard: $text', name: 'AddMoney');
    Get.snackbar(
      "Copied",
      "$label copied to clipboard",
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      colorText: AppColors.primaryColor,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Icons.check_circle, color: AppColors.primaryColor),
    );
  }

  void shareAccountDetails(String accountNumber, String bankName) {
    dev.log('Sharing account details: $accountNumber - $bankName',
        name: 'AddMoney');
    // Implement share functionality
    Get.snackbar(
      "Share",
      "Share functionality will be implemented here",
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.successBgColor,
      colorText: AppColors.textSnackbarColor,
    );
  }

  void navigateToCardTopUp() {
    dev.log('Navigating to Card Top Up', name: 'AddMoney');
    Get.toNamed(Routes.CARD_TOPUP_MODULE);
  }

  void navigateToUssd() {
    dev.log('Navigating to USSD Top-up', name: 'AddMoney');
    Get.toNamed(Routes.USSD_TOPUP_MODULE);
  }

  void navigateToMomo() {
    dev.log('Navigating to Momo Top-up', name: 'AddMoney');
    Get.toNamed(Routes.MOMO_MODULE);
  }
}
