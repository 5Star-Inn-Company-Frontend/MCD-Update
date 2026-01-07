import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;
import 'models/pos_terminal_model.dart';

class PosRequestNewTermModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final selectedTerminalType = ''.obs;
  final terminals = <PosTerminalModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosRequestNewTermModuleController initialized', name: 'PosRequestNewTerm');
    fetchAvailableTerminals();
  }

  @override
  void onClose() {
    dev.log('PosRequestNewTermModuleController disposed', name: 'PosRequestNewTerm');
    super.onClose();
  }

  Future<void> fetchAvailableTerminals() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null) {
        dev.log('Utility URL not found', name: 'PosRequestNewTerm', error: 'URL missing');
        errorMessage.value = 'Service configuration error. Please login again.';
        isLoading.value = false;
        return;
      }

      dev.log('Fetching available POS terminals', name: 'PosRequestNewTerm');
      
      final result = await apiService.getrequest('${utilityUrl}pos-available');

      result.fold(
        (failure) {
          dev.log('Failed to fetch POS terminals', name: 'PosRequestNewTerm', error: failure.message);
          errorMessage.value = failure.message;
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1 && data['data'] != null) {
            dev.log('POS terminals fetched successfully', name: 'PosRequestNewTerm');
            
            final terminalList = (data['data'] as List)
                .map((json) => PosTerminalModel.fromJson(json))
                .where((terminal) => terminal.status == 1) // Only active terminals
                .toList();
            
            terminals.value = terminalList;
            dev.log('Loaded ${terminals.length} available terminals', name: 'PosRequestNewTerm');
          } else {
            dev.log('Failed to fetch POS terminals', name: 'PosRequestNewTerm', error: data['message']);
            errorMessage.value = data['message'] ?? 'Failed to fetch terminals';
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching POS terminals', name: 'PosRequestNewTerm', error: e);
      errorMessage.value = 'An error occurred while fetching terminals';
    } finally {
      isLoading.value = false;
    }
  }

  void selectTerminal(PosTerminalModel terminal) {
    selectedTerminalType.value = terminal.name;
    Get.toNamed('/pos_term_req_form', arguments: {
      'terminalType': terminal.name,
      'terminal': terminal,
    });
  }
}
