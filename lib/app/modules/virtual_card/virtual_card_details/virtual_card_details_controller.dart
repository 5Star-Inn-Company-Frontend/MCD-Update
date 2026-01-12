import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/modules/virtual_card/models/virtual_card_model.dart';
import 'dart:developer' as dev;

class VirtualCardDetailsController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final pageController = PageController();
  final isCardDetailsHidden = true.obs;
  final cardBalance = 0.0.obs;
  final isFetchingBalance = false.obs;
  final isFreezing = false.obs;
  final isUnfreezing = false.obs;
  final isDeleting = false.obs;

  int? selectedCardId;

  final card = Rxn<VirtualCardModel>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['cardModel'] != null) {
      card.value = args['cardModel'];
      selectedCardId = card.value!.id;
      // Initialize balance from the passed model, then refresh it
      cardBalance.value = card.value!.balance;
      fetchCardBalance(selectedCardId!);
    } else if (args != null && args['cardId'] != null) {
      // Fallback if only ID is passed (e.g. deep link)
      selectedCardId = args['cardId'];
      fetchCardBalance(selectedCardId!);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchCardBalance(int cardId) async {
    try {
      isFetchingBalance.value = true;
      dev.log('Fetching balance for card $cardId');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService
          .getrequest('${transactionUrl}virtual-card/balance/$cardId');

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
            cardBalance.value =
                double.tryParse(data['data']['balance']?.toString() ?? '0') ??
                    0.0;
            dev.log('Success: Balance loaded - \$${cardBalance.value}');
          } else {
            dev.log('Error: ${data['message']}');
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
    } finally {
      isFetchingBalance.value = false;
    }
  }

  Future<void> freezeCard(int cardId) async {
    try {
      isFreezing.value = true;
      dev.log('Freezing card $cardId');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService
          .patchrequest('${transactionUrl}virtual-card/freeze/$cardId', {});

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
              data['message']?.toString() ?? 'Card frozen successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          } else {
            dev.log('Error: ${data['message']}');
            Get.snackbar(
              'Error',
              data['message']?.toString() ?? 'Failed to freeze card',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
    } finally {
      isFreezing.value = false;
    }
  }

  Future<void> unfreezeCard(int cardId) async {
    try {
      isUnfreezing.value = true;
      dev.log('Unfreezing card $cardId');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService
          .patchrequest('${transactionUrl}virtual-card/unfreeze/$cardId', {});

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
              data['message']?.toString() ?? 'Card unfrozen successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          } else {
            dev.log('Error: ${data['message']}');
            Get.snackbar(
              'Error',
              data['message']?.toString() ?? 'Failed to unfreeze card',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
    } finally {
      isUnfreezing.value = false;
    }
  }

  Future<void> deleteCard(int cardId) async {
    try {
      isDeleting.value = true;
      dev.log('Deleting card $cardId');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService
          .deleterequest('${transactionUrl}virtual-card/delete/$cardId');

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
            Get.back();
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
