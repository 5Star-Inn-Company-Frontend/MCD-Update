import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosHomeModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final activeTerminals = <Map<String, dynamic>>[].obs;
  final inactiveTerminals = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosHomeModuleController initialized', name: 'PosHome');
    fetchTerminals();
  }

  @override
  void onClose() {
    dev.log('PosHomeModuleController disposed', name: 'PosHome');
    super.onClose();
  }

  Future<void> fetchTerminals() async {
    try {
      isLoading.value = true;
      
      // TODO: Replace with actual API endpoint
      // final response = await apiService.get('/pos/terminals');
      
      // Mock data - replace with actual API response
      await Future.delayed(const Duration(seconds: 1));
      
      activeTerminals.value = [
        {'terminalId': '2033QW9-', 'status': 'active'},
        {'terminalId': '2033QW8-', 'status': 'active'},
        {'terminalId': '2033QW7-', 'status': 'active'},
      ];
      
      inactiveTerminals.value = [
        {'terminalId': '2033QW6-', 'status': 'inactive'},
      ];
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      dev.log('Error fetching terminals: $e', name: 'PosHome');
    }
  }

  void navigateToTerminalDetails(Map<String, dynamic> terminal) {
    Get.toNamed('/pos_terminal_details', arguments: terminal);
  }

  void navigateToRequestNewTerminal() {
    Get.toNamed('/pos_request_new_term');
  }

  void navigateToTerminalRequests() {
    Get.toNamed('/pos_terminal_requests');
  }

  void navigateToMapTerminal() {
    Get.toNamed('/pos_map_term');
  }
}
