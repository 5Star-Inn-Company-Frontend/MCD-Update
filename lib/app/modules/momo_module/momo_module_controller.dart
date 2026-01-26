import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer' as dev;

class MomoModuleController extends GetxController {
  final apiService = DioApiService();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Selection State
  final selectedCurrency = Rxn<String>();
  final selectedProvider = Rxn<Map<String, dynamic>>();

  // Form Controllers
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Data
  final currencies = <String>[].obs;
  final providers = <Map<String, dynamic>>[].obs;

  // UI Stage (0: Input, 1: Success/Completion)
  final currentStage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrencies();
  }

  @override
  void onClose() {
    phoneController.dispose();
    amountController.dispose();
    super.onClose();
  }

  Future<void> fetchCurrencies() async {
    try {
      isLoading.value = true;
      final box = GetStorage();
      final utilityUrl = box.read('utility_service_url');

      if (utilityUrl == null) {
        dev.log('Utility URL not found', name: 'MomoModule');
        // Fallback or just return
        return;
      }

      final url = '${utilityUrl}payment/momo/currencies';
      dev.log('Fetching currencies from: $url', name: 'MomoModule');

      final result = await apiService.getrequest(url);

      result.fold(
        (failure) {
          dev.log('Failed to fetch currencies: ${failure.message}',
              name: 'MomoModule');
          Get.snackbar('Error', 'Failed to load currencies',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.white);
        },
        (data) {
          if (data['success'] == 1 && data['data'] != null) {
            final List<dynamic> list = data['data'];
            currencies.value = list.cast<String>();
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching currencies', error: e, name: 'MomoModule');
    } finally {
      isLoading.value = false;
    }
  }

  void onCurrencyChanged(String? value) {
    if (value == null) return;
    selectedCurrency.value = value;
    selectedProvider.value = null; // Reset provider
    providers.clear();
    fetchProviders(value);
  }

  Future<void> fetchProviders(String currency) async {
    try {
      isLoading.value = true;
      final box = GetStorage();
      final utilityUrl = box.read('utility_service_url');

      if (utilityUrl == null) return;

      final url = '${utilityUrl}payment/momo/providers/$currency';
      dev.log('Fetching providers from: $url', name: 'MomoModule');

      final result = await apiService.getrequest(url);

      result.fold((failure) {
        Get.snackbar('Error', failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.white);
      }, (data) {
        if (data['success'] == 1 && data['data'] != null) {
          final List<dynamic> providerList = data['data'];
          providers.value = providerList.cast<Map<String, dynamic>>();
        }
      });
    } catch (e) {
      dev.log('Error fetching providers', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> proceed() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCurrency.value == null || selectedProvider.value == null) {
      Get.snackbar('Error', 'Please select currency and provider',
          backgroundColor: AppColors.errorBgColor, colorText: AppColors.white);
      return;
    }

    // Simulate sucessful submission for now as per plan
    isSubmitting.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSubmitting.value = false;
    currentStage.value = 1; // Move to completion screen
  }
}
