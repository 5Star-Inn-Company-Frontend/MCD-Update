import 'package:flutter/services.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/features/home/data/model/dashboard_model.dart';
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
    dev.log('Sharing account details: $accountNumber - $bankName', name: 'AddMoney');
    // Implement share functionality
    Get.snackbar(
      "Share",
      "Share functionality will be implemented here",
      snackPosition: SnackPosition.TOP,
    );
  }

  void navigateToCardTopUp() {
    dev.log('Navigating to Card Top Up', name: 'AddMoney');
    Get.toNamed('/card-top-up'); // You'll need to add this route
  }

  void navigateToUssd() {
    dev.log('Navigating to USSD', name: 'AddMoney');
    Get.toNamed('/ussd'); // You'll need to add this route
  }
}