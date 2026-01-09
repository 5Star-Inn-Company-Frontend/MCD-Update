import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/virtual_card/models/virtual_card_transaction_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class VirtualCardTransactionsController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final isLoading = false.obs;
  final transactions = <VirtualCardTransactionModel>[].obs;

  int? selectedCardId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['cardId'] != null) {
      selectedCardId = args['cardId'];
      fetchTransactions(selectedCardId!);
    }
  }

  Future<void> fetchTransactions(int cardId) async {
    try {
      isLoading.value = true;
      dev.log('Fetching transactions for card $cardId');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService.getrequest('${transactionUrl}virtual-card/transactions/$cardId');

      result.fold(
        (failure) {
          dev.log('Error: ${failure.message}');
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          final response = VirtualCardTransactionListResponse.fromJson(data);
          if (response.success == 1) {
            transactions.value = response.transactions;
            dev.log('Success: Loaded ${response.transactions.length} transactions');
          } else {
            dev.log('Error: ${response.message}');
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
