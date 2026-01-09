import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/virtual_card/models/virtual_card_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class VirtualCardHomeController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final isLoading = false.obs;
  final cards = <VirtualCardModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVirtualCards();
  }

  Future<void> fetchVirtualCards() async {
    try {
      isLoading.value = true;
      dev.log('Fetching virtual cards');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService.getrequest('${transactionUrl}virtual-card/list');

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
          final response = VirtualCardListResponse.fromJson(data);
          if (response.success == 1) {
            cards.value = response.cards;
            dev.log('Success: Loaded ${response.cards.length} cards');
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