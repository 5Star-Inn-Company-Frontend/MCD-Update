import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import './models/pos_request_model.dart';
import 'dart:developer' as dev;

class PosTerminalRequestsModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  
  final terminalRequests = <PosRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTerminalRequestsModuleController initialized', name: 'PosTerminalRequests');
    fetchPosRequests();
  }

  @override
  void onClose() {
    dev.log('PosTerminalRequestsModuleController disposed', name: 'PosTerminalRequests');
    super.onClose();
  }

  Future<void> fetchPosRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null) {
        isLoading.value = false;
        errorMessage.value = 'Service configuration error. Please login again.';
        return;
      }

      dev.log('Fetching POS requests from: ${utilityUrl}pos-request', name: 'PosTerminalRequests');

      final result = await apiService.getrequest('${utilityUrl}pos-request');

      result.fold(
        (failure) {
          isLoading.value = false;
          errorMessage.value = failure.message;
          dev.log('Failed to fetch POS requests', name: 'PosTerminalRequests', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          isLoading.value = false;
          dev.log('POS requests fetched successfully', name: 'PosTerminalRequests');
          
          if (data['success'] == 1 && data['data'] != null) {
            final List<dynamic> requestsData = data['data'];
            terminalRequests.value = requestsData
                .map((json) => PosRequestModel.fromJson(json))
                .toList();
            
            // Sort by created date (newest first)
            terminalRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            
            dev.log('Loaded ${terminalRequests.length} POS requests', name: 'PosTerminalRequests');
          } else {
            errorMessage.value = data['message'] ?? 'Failed to load requests';
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred while fetching requests';
      dev.log('Error fetching POS requests', name: 'PosTerminalRequests', error: e);
    }
  }

  void retryFetch() {
    fetchPosRequests();
  }
}
