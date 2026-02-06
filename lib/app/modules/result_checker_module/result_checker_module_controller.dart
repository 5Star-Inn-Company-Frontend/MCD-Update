import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/general_payout/general_payout_controller.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';

class ResultCheckerModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final selectedExam = Rx<Map<String, dynamic>?>(null);
  final exams = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final optionType = Rx<String>('token');
  final pageTitle = Rx<String>('Result Checker Token');

  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // get option type from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['type'] != null) {
      optionType.value = args['type'];
      _updatePageTitle();
    }

    fetchExams();
  }

  void _updatePageTitle() {
    switch (optionType.value) {
      case 'token':
        pageTitle.value = 'Result Checker Token';
        break;
      case 'jamb':
        pageTitle.value = 'JAMB Pin';
        break;
      case 'registration':
        pageTitle.value = 'Registration Pin';
        break;
      default:
        pageTitle.value = 'Result Checker';
    }
  }

  // fetch exams from api
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

      final url = '${transactionUrl}exams';
      dev.log('Fetching exams from: $url', name: 'ResultChecker');

      final result = await apiService.getrequest(url);

      result.fold(
        (failure) {
          dev.log('Failed to fetch exams',
              name: 'ResultChecker', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (response) {
          dev.log('Exams response: $response', name: 'ResultChecker');
          if (response['data'] != null && response['data'] is List) {
            exams.value = List<Map<String, dynamic>>.from(response['data']);
            // auto-select first exam if available
            if (exams.isNotEmpty) {
              selectedExam.value = exams.first;
            }
          }
        },
      );
    } catch (e) {
      dev.log('Exception fetching exams', name: 'ResultChecker', error: e);
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

  @override
  void onClose() {
    phoneController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void selectExam(Map<String, dynamic> exam) {
    selectedExam.value = exam;
  }

  // getters for selected exam
  String get examName => selectedExam.value?['name'] ?? '';
  String get examCode => selectedExam.value?['code'] ?? '';
  String get examPrice =>
      (selectedExam.value?['price'] ?? selectedExam.value?['amount'] ?? 0)
          .toString();

  void handlePayment() {
    if (selectedExam.value == null) {
      Get.snackbar(
        'Error',
        'Please select an exam type',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    final quantity = amountController.text.trim();
    if (quantity.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter quantity (1-10)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    final quantityInt = int.tryParse(quantity);
    if (quantityInt == null || quantityInt < 1 || quantityInt > 10) {
      Get.snackbar(
        'Error',
        'Quantity must be between 1 and 10',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    // calculate total amount using price from api
    final pricePerUnit = double.tryParse(examPrice) ?? 0;
    final totalAmount = (quantityInt * pricePerUnit).toStringAsFixed(0);

    Get.toNamed(
      Routes.GENERAL_PAYOUT,
      arguments: {
        'paymentType': PaymentType.resultChecker,
        'paymentData': {
          'examName': examName,
          'examCode': examCode,
          'quantity': quantity,
          'amount': totalAmount,
          'pricePerUnit': examPrice,
          'selectedExam': selectedExam.value,
        },
      },
    );
  }
}
