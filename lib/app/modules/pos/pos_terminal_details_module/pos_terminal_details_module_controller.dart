import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTerminalDetailsModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final terminalId = ''.obs;
  final businessName = 'GiftBills'.obs;
  final terminalType = 'MP35P'.obs;
  final serialNumber = '3D903534'.obs;
  final availableBalance = 0.0.obs;
  final cashbackBalance = 0.0.obs;
  final currentLevel = 'Star 2'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTerminalDetailsModuleController initialized', name: 'PosTerminalDetails');
    
    // Get terminal data from arguments
    if (Get.arguments != null) {
      final terminal = Get.arguments as Map<String, dynamic>;
      terminalId.value = terminal['terminalId'] ?? '';
    }
    
    fetchTerminalDetails();
  }

  @override
  void onClose() {
    dev.log('PosTerminalDetailsModuleController disposed', name: 'PosTerminalDetails');
    super.onClose();
  }

  Future<void> fetchTerminalDetails() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API endpoint
      // final response = await apiService.get('/pos/terminal/${terminalId.value}');
      
      // Mock data - replace with actual API response
      await Future.delayed(const Duration(seconds: 1));
      
      availableBalance.value = 8987374.0;
      cashbackBalance.value = 500.0;
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      dev.log('Error fetching terminal details: $e', name: 'PosTerminalDetails');
    }
  }

  void navigateToAddFunds() {
    // TODO: Implement add funds navigation
    dev.log('Navigate to add funds', name: 'PosTerminalDetails');
  }

  void navigateToWithdrawal() {
    Get.toNamed('/pos_withdrawal', arguments: {
      'terminalId': terminalId.value,
      'availableBalance': availableBalance.value,
    });
  }

  void navigateToStarLevels() {
    // TODO: Implement star levels navigation
    dev.log('Navigate to star levels', name: 'PosTerminalDetails');
  }

  void navigateToTransactionHistory() {
    Get.toNamed('/pos_terminal_transaction_history', arguments: {
      'terminalId': terminalId.value,
    });
  }

  void navigateToSettings() {
    Get.toNamed('/pos_terminal_settings', arguments: {
      'terminalId': terminalId.value,
    });
  }

  void navigateToDailyReport() {
    // TODO: Implement daily report navigation
    dev.log('Navigate to daily report', name: 'PosTerminalDetails');
  }
}
