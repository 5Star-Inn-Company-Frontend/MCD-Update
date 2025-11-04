import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/electricity_module/model/electricity_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_service.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class ElectricityModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final meterNoController = TextEditingController();
  final amountController = TextEditingController();

  final electricityProviders = <ElectricityProvider>[].obs;
  final selectedProvider = Rxn<ElectricityProvider>();
  final paymentTypes = ['Prepaid', 'Postpaid'].obs;
  final selectedPaymentType = 'Prepaid'.obs;

  final isLoading = true.obs;
  final isPaying = false.obs;
  final isValidating = false.obs;
  final errorMessage = RxnString();
  final validatedCustomerName = RxnString();

  final Map<String, String> providerImages = {
    'IKEDC': 'assets/images/electricity/IKEDC.png',
    'EKEDC': 'assets/images/electricity/EKEDC.png',
    'IBEDC': 'assets/images/electricity/IBEDC.png',
    'KEDCO': 'assets/images/electricity/KEDCO.png',
    'PHED': 'assets/images/electricity/PHED.png',
    'JED': 'assets/images/electricity/JED.png',
    'KAEDCO': 'assets/images/electricity/KAEDCO.png',
    'AEDC': 'assets/images/electricity/AEDC.png',
    'EEDC': 'assets/images/electricity/EEDC.png',
    'DEFAULT': 'assets/images/electricity/ABA.png',
  };

  @override
  void onInit() {
    super.onInit();
    dev.log('ElectricityModuleController initialized', name: 'ElectricityModule');
    fetchElectricityProviders();

    // Add listener for auto-validation
    meterNoController.addListener(() {
      if (meterNoController.text.isEmpty) {
        validatedCustomerName.value = null;
        dev.log('Meter number cleared', name: 'ElectricityModule');
      }
      debounce(
        validatedCustomerName,
        (_) {
          if (meterNoController.text.isNotEmpty && selectedProvider.value != null) {
            dev.log('Triggering validation for meter: ${meterNoController.text}', name: 'ElectricityModule');
            validateMeterNumber();
          }
        },
        time: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  void onClose() {
    meterNoController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onProviderSelected(ElectricityProvider? provider) {
    if (provider != null) {
      selectedProvider.value = provider;
      validatedCustomerName.value = null;
      dev.log('Provider selected: ${provider.name}', name: 'ElectricityModule');
      if (meterNoController.text.isNotEmpty) {
        validateMeterNumber();
      }
    }
  }

  void onPaymentTypeSelected(String? type) {
    if (type != null) {
      selectedPaymentType.value = type;
      dev.log('Payment type selected: $type', name: 'ElectricityModule');
    }
  }

  void onAmountSelected(String amount) {
    amountController.text = amount;
    dev.log('Amount selected: ₦$amount', name: 'ElectricityModule');
  }

  Future<void> fetchElectricityProviders() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      dev.log('Fetching electricity providers...', name: 'ElectricityModule');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        errorMessage.value = "Service URL not found.";
        dev.log('Transaction URL not found', name: 'ElectricityModule', error: errorMessage.value);
        return;
      }

      final fullUrl = '$transactionUrl''electricity';
      dev.log('Request URL: $fullUrl', name: 'ElectricityModule');
      final result = await apiService.getJsonRequest(fullUrl);

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log('Failed to fetch providers', name: 'ElectricityModule', error: failure.message);
        },
        (data) {
          dev.log('Providers fetched successfully', name: 'ElectricityModule');
          if (data['data'] != null && data['data'] is List) {
            final providers = (data['data'] as List)
                .map((item) => ElectricityProvider.fromJson(item))
                .toList();
            electricityProviders.assignAll(providers);
            dev.log('Loaded ${providers.length} providers', name: 'ElectricityModule');
            if (providers.isNotEmpty) {
              selectedProvider.value = providers.first;
              dev.log('Auto-selected provider: ${selectedProvider.value?.name}', name: 'ElectricityModule');
            }
          } else {
            errorMessage.value = "No providers found.";
            dev.log('No providers in response', name: 'ElectricityModule', error: errorMessage.value);
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> validateMeterNumber() async {
    isValidating.value = true;
    validatedCustomerName.value = null;
    dev.log('Validating meter: ${meterNoController.text} for provider: ${selectedProvider.value?.code}', name: 'ElectricityModule');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found during validation', name: 'ElectricityModule', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.");
        return;
      }

      final body = {
        "service": "electricity",
        "provider": selectedProvider.value!.code.toLowerCase(),
        "number": meterNoController.text,
      };

      dev.log('Validation request body: $body', name: 'ElectricityModule');
      final result = await apiService.postJsonRequest('$transactionUrl''validate', body);

      result.fold(
        (failure) {
          dev.log('Validation failed', name: 'ElectricityModule', error: failure.message);
          Get.snackbar("Validation Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          dev.log('Validation response: $data', name: 'ElectricityModule');
          if (data['success'] == 1 && data['data']?['name'] != null) {
            validatedCustomerName.value = data['data']['name'];
            dev.log('Meter validated successfully: ${validatedCustomerName.value}', name: 'ElectricityModule');
            Get.snackbar("Validation Successful", "Customer: ${validatedCustomerName.value}", backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            dev.log('Validation unsuccessful', name: 'ElectricityModule', error: data['message']);
            Get.snackbar("Validation Failed", data['message'] ?? "Could not validate meter number.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } finally {
      isValidating.value = false;
    }
  }

  void pay() {
    dev.log('Payment initiated', name: 'ElectricityModule');

    if (selectedProvider.value == null) {
      dev.log('Payment failed: No provider selected', name: 'ElectricityModule', error: 'Provider missing');
      Get.snackbar("Error", "Please select an electricity provider.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    if (meterNoController.text.isEmpty) {
      dev.log('Payment failed: No meter number', name: 'ElectricityModule', error: 'Meter number missing');
      Get.snackbar("Error", "Please enter your meter number.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    if (validatedCustomerName.value == null) {
      dev.log('Payment failed: Meter not validated', name: 'ElectricityModule', error: 'Validation missing');
      Get.snackbar("Error", "Please validate your meter number first.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      dev.log('Navigating to payout with: Provider=${selectedProvider.value?.name}, Amount=₦${amountController.text}', name: 'ElectricityModule');
      Get.toNamed(
        Routes.ELECTRICITY_PAYOUT_MODULE,
        arguments: {
          'provider': selectedProvider.value,
          'meterNumber': meterNoController.text,
          'amount': double.tryParse(amountController.text) ?? 0.0,
          'paymentType': selectedPaymentType.value,
          'customerName': validatedCustomerName.value,
        },
      );
    }
  }
}