import 'dart:developer' as dev;
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/dio_api_service.dart';

class JambModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final selectedExam = Rx<Map<String, dynamic>?>(null);
  final isLoading = false.obs;
  final options = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExams();
  }

  // fetch exam options from api
  Future<void> fetchExams() async {
    try {
      isLoading.value = true;

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'Service URL not found. Please log in again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      final url = '${transactionUrl}jamb';
      dev.log('Fetching from: $url', name: 'JambModule');

      final result = await apiService.getrequest(url);

      result.fold(
        (failure) {
          dev.log('Failed to fetch exams',
              name: 'JambModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (response) {
          dev.log('Exams response: $response', name: 'JambModule');
          if (response['data'] != null && response['data'] is List) {
            options.value = List<Map<String, dynamic>>.from(response['data']);
          }
        },
      );
    } catch (e) {
      dev.log('Exception while fetching exams', name: 'JambModule', error: e);
      Get.snackbar(
        'Error',
        'Failed to fetch exam options',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectOption(Map<String, dynamic> exam) {
    selectedExam.value = exam;
  }

  void proceedToVerify() {
    if (selectedExam.value == null) {
      Get.snackbar(
        'Selection Required',
        'Please select an exam type to proceed',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    Get.toNamed(
      Routes.JAMB_VERIFY_ACCOUNT_MODULE,
      arguments: {'selectedExam': selectedExam.value},
    );
  }
}
