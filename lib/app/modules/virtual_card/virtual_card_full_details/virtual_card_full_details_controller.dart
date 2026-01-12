import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/virtual_card/models/virtual_card_model.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/modules/virtual_card/virtual_card_home/virtual_card_home_controller.dart';
import 'dart:developer' as dev;

class VirtualCardFullDetailsController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final isDetailsVisible = false.obs;
  final card = Rxn<VirtualCardModel>();
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['cardModel'] != null) {
      card.value = args['cardModel'];
    }
  }

  void toggleDetails() {
    isDetailsVisible.value = !isDetailsVisible.value;
  }

  Future<void> deleteCard() async {
    if (card.value == null) return;

    try {
      isDeleting.value = true;
      dev.log('Deleting card ${card.value!.id}');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService.deleterequest(
          '${transactionUrl}virtual-card/delete/${card.value!.id}');

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
          if (data['success'] == 1) {
            dev.log('Success: ${data['message']}');
            Get.snackbar(
              'Success',
              data['message']?.toString() ?? 'Card deleted successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );

            // Refresh home list
            if (Get.isRegistered<VirtualCardHomeController>()) {
              Get.find<VirtualCardHomeController>().refreshCards();
            }

            // Navigate back to Home (pop full details AND details)
            Get.until((route) => route.settings.name == '/virtual-card-home');
            // Or just close enough
            // Get.close(2);
          } else {
            dev.log('Error: ${data['message']}');
            Get.snackbar(
              'Error',
              data['message']?.toString() ?? 'Failed to delete card',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
    } finally {
      isDeleting.value = false;
    }
  }
}
