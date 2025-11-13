import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class TransactionDetailModuleController extends GetxController {
  var apiService = DioApiService();
  final box = GetStorage();

  late final String name;
  late final String image;
  late final double amount;
  late final String paymentType;
  late final String paymentMethod;
  late final String userId;
  late final String customerName;
  late final String transactionId;
  late final String packageName;
  late final String token;
  late final String date;

  final _isRepeating = false.obs;
  bool get isRepeating => _isRepeating.value;

  @override
  void onInit() {
    super.onInit();
    dev.log('TransactionDetailModuleController initialized', name: 'TransactionDetail');

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      name = arguments['name'] ?? 'Unknown Transaction';
      image = arguments['image'] ?? '';
      amount = arguments['amount'] ?? 0.0;
      paymentType = arguments['paymentType'] ?? 'Type';
      paymentMethod = arguments['paymentMethod'] ?? 'Wallet';
      userId = arguments['userId'] ?? 'N/A';
      customerName = arguments['customerName'] ?? 'N/A';
      transactionId = arguments['transactionId'] ?? 'N/A';
      packageName = arguments['packageName'] ?? 'N/A';
      token = arguments['token'] ?? 'N/A';
      date = arguments['date'] ?? '';
      
      dev.log('Transaction details loaded - Type: $paymentType, Amount: ₦$amount, ID: $transactionId, Payment Method: $paymentMethod', name: 'TransactionDetail');
    } else {
      name = 'Error: No data received';
      image = '';
      amount = 0.0;
      paymentType = 'Type';
      paymentMethod = 'Wallet';
      userId = 'N/A';
      customerName = 'N/A';
      transactionId = 'N/A';
      packageName = 'N/A';
      token = 'N/A';
      date = 'N/A';

      dev.log('No transaction arguments received', name: 'TransactionDetail', error: 'Arguments missing');
    }
  }

  void copyToken() {
    if (token != 'N/A') {
      dev.log('Token copied to clipboard: $token', name: 'TransactionDetail');
    }
  }

  // Repeat transaction (Buy Again)
  Future<void> repeatTransaction() async {
    if (transactionId == 'N/A' || transactionId.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot repeat transaction: Invalid transaction ID',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      _isRepeating.value = true;
      dev.log('Repeating transaction: $transactionId', name: 'TransactionDetail');

      final transactionUrl = box.read('transaction_service_url') ?? '';
      final url = '${transactionUrl}transaction/repeat';
      dev.log('Repeat URL: $url', name: 'TransactionDetail');

      final body = {
        'ref': transactionId,
      };

      final response = await apiService.postrequest(url, body);

      response.fold(
        (failure) {
          dev.log('Failed to repeat transaction', name: 'TransactionDetail', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 2),
          );
        },
        (data) {
          dev.log('Repeat transaction response: $data', name: 'TransactionDetail');
          if (data['success'] == 1) {
            Get.snackbar(
              'Success',
              data['message'] ?? 'Transaction repeated successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 2),
            );
            // Navigate back after successful repeat
            Future.delayed(const Duration(seconds: 2), () {
              Get.back();
            });
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to repeat transaction',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error repeating transaction', name: 'TransactionDetail', error: e);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isRepeating.value = false;
    }
  }
}