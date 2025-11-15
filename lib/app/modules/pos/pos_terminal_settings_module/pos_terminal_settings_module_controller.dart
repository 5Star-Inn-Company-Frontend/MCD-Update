import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTerminalSettingsModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final disableBankTransfer = false.obs;
  final disableBillsPayment = false.obs;
  final disableCardTransfer = false.obs;

  void saveSettings() {
    Get.snackbar('Success', 'Settings saved successfully');
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTerminalSettingsModuleController initialized', name: 'PosTerminalSettings');
  }

  @override
  void onClose() {
    dev.log('PosTerminalSettingsModuleController disposed', name: 'PosTerminalSettings');
    super.onClose();
  }
}
