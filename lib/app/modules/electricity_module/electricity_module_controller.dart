import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/electricity_module/model/electricity_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/api_service.dart';

class ElectricityModuleController extends GetxController {
  final apiService = ApiService();
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
  final errorMessage = RxnString();

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
    fetchElectricityProviders();
  }

  @override
  void onClose() {
    meterNoController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onProviderSelected(ElectricityProvider? provider) {
    if (provider != null) selectedProvider.value = provider;
  }

  void onPaymentTypeSelected(String? type) {
    if (type != null) selectedPaymentType.value = type;
  }

  void onAmountSelected(String amount) {
    amountController.text = amount;
  }

  Future<void> fetchElectricityProviders() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        errorMessage.value = "Service URL not found.";
        return;
      }
      final result = await apiService.getJsonRequest('$transactionUrl''electricity');
      result.fold(
        (failure) => errorMessage.value = failure.message,
        (data) {
          if (data['data'] != null && data['data'] is List) {
            final providers = (data['data'] as List)
                .map((item) => ElectricityProvider.fromJson(item))
                .toList();
            electricityProviders.assignAll(providers);
            if (providers.isNotEmpty) selectedProvider.value = providers.first;
          } else {
            errorMessage.value = "No providers found.";
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void pay() {
    if (formKey.currentState?.validate() ?? false) {
      Get.toNamed(
        Routes.ELECTRICITY_PAYOUT_MODULE,
        arguments: {
          'provider': selectedProvider.value,
          'meterNumber': meterNoController.text,
          'amount': double.tryParse(amountController.text) ?? 0.0,
          'paymentType': selectedPaymentType.value,
        },
      );
    }
  }
}