import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/modules/data_module/model/data_plan_model.dart';
import 'package:mcd/app/modules/data_module/network_provider.dart';
import 'package:mcd/app/styles/app_colors.dart';

import '../../../core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class DataModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final phoneController = TextEditingController();
  final networkProviders = <NetworkProvider>[].obs;
  final selectedNetworkProvider = Rxn<NetworkProvider>();
  
  // State for the data plans
  final _allDataPlansForNetwork = <DataPlanModel>[].obs;
  final filteredDataPlans = <DataPlanModel>[].obs;
  final selectedPlan = Rxn<DataPlanModel>(); // To track the tapped plan

  // State for the custom tab bar, mimicking the old UI
  final tabBarItems = ['Daily', 'Night', 'Weekend', 'Weekly', 'Monthly'].obs;
  final selectedTab = 'Daily'.obs;
  
  // Loading and Error States
  final isLoading = true.obs;
  final isPaying = false.obs;
  final errorMessage = RxnString();
  final selectedPaymentMethod = 'wallet'.obs; // wallet, paystack, general_market, mega_bonus

  @override
  void onInit() {
    super.onInit();
    // Check if we have a verified number and network from navigation
    final verifiedNumber = Get.arguments?['verifiedNumber'];
    final verifiedNetwork = Get.arguments?['verifiedNetwork'];
    
    if (verifiedNumber != null) {
      phoneController.text = verifiedNumber;
    }
    
    networkProviders.value = NetworkProvider.all;
    
    // Pre-select network if verified
    if (verifiedNetwork != null && networkProviders.isNotEmpty) {
      dev.log('🔍 Data Module - Trying to match network: "$verifiedNetwork"');
      dev.log('📋 Available providers: ${networkProviders.map((p) => p.name).join(", ")}');
      
      // Normalize the network name for matching
      final normalizedInput = _normalizeNetworkName(verifiedNetwork);
      dev.log('🔄 Normalized input: "$normalizedInput"');
      
      final matchedProvider = networkProviders.firstWhereOrNull(
        (provider) => _normalizeNetworkName(provider.name) == normalizedInput
      );
      
      if (matchedProvider != null) {
        onNetworkSelected(matchedProvider);
        dev.log('✅ Pre-selected verified network: ${matchedProvider.name}');
      } else {
        onNetworkSelected(networkProviders.first);
        dev.log('❌ Network "$verifiedNetwork" not found, auto-selected first: ${networkProviders.first.name}');
      }
    } else if (networkProviders.isNotEmpty) {
      onNetworkSelected(networkProviders.first);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void onNetworkSelected(NetworkProvider? provider) {
    if (provider == null || provider == selectedNetworkProvider.value) return;
    selectedNetworkProvider.value = provider;
    fetchDataPlansForNetwork();
  }

  void onTabSelected(String tabName) {
    selectedTab.value = tabName;
    _filterPlansByTab();
  }

  void onPlanSelected(DataPlanModel plan) {
    selectedPlan.value = plan;
  }
  
  void setPaymentMethod(String method) {
    dev.log('Setting payment method: $method', name: 'DataModule');
    selectedPaymentMethod.value = method;
  }
  
  /// Normalize network name for consistent matching
  String _normalizeNetworkName(String networkName) {
    final normalized = networkName.toLowerCase().trim();
    
    // Handle common variations
    if (normalized.contains('mtn')) return 'mtn';
    if (normalized.contains('airtel')) return 'airtel';
    if (normalized.contains('glo')) return 'glo';
    if (normalized.contains('9mobile') || normalized.contains('etisalat') || normalized == '9mob') return '9mobile';
    
    return normalized;
  }

  Future<void> fetchDataPlansForNetwork() async {
    if (selectedNetworkProvider.value == null) return;
    try {
      isLoading.value = true;
      errorMessage.value = null;
      _allDataPlansForNetwork.clear();
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        errorMessage.value = "Service URL not found.";
        return;
      }
      final networkName = selectedNetworkProvider.value!.name.toUpperCase();
      final result = await apiService.getrequest('$transactionUrl''data/$networkName');
      result.fold(
        (failure) => errorMessage.value = failure.message,
        (data) {
          if (data['data'] != null && data['data'] is List) {
            final plansJson = data['data'] as List;
            tabBarItems.assignAll(plansJson.map((item) => item['category'] as String).toSet().toList());
            _allDataPlansForNetwork.assignAll(plansJson.map((item) => DataPlanModel.fromJson(item)));
            onTabSelected(tabBarItems.first); // Automatically select the first tab and filter
          } else {
            _allDataPlansForNetwork.clear();
            filteredDataPlans.clear();
            errorMessage.value = "No data plans found for this network.";
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _filterPlansByTab() {
    // This logic assumes categories from the API match the tab names.
    // e.g., 'Daily', 'SME', 'Gifting'. You may need to adjust this mapping.
    String filterKey = selectedTab.value.toUpperCase();
    if (filterKey == 'DAILY') {
        // Example: If your API uses a different name like 'SME' for daily plans
        // filterKey = 'SME'; 
    }
    
    filteredDataPlans.assignAll(_allDataPlansForNetwork.where((plan) => plan.category.toUpperCase() == filterKey));
    selectedPlan.value = null; // Clear selection when tab changes
  }

  void pay() async {
    if (selectedPlan.value == null) {
      Get.snackbar("Error", "Please select a data plan to purchase.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    isPaying.value = true;
    try {
      final transactionUrl = box.read('transaction_service_url');
      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

      final body = {
        "coded": selectedPlan.value!.coded,
        "number": phoneController.text,
        "payment": selectedPaymentMethod.value,
        "promo": "0",
        "ref": ref,
        "country": "NG"
      };

      dev.log('Data payment request with payment: ${selectedPaymentMethod.value}', name: 'DataModule');
      final result = await apiService.postrequest('$transactionUrl''data', body);

      result.fold(
        (failure) {
          Get.snackbar("Payment Failed", failure.message, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          if (data['success'] == 1) {
            final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
            final debitAmount = data['debitAmount'] ?? data['amount'] ?? selectedPlan.value!.price;
            
            Get.snackbar("Success", data['message'] ?? "Data purchase successful!", backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
            // Navigate to transaction details screen on success
            Get.toNamed(Routes.TRANSACTION_DETAIL_MODULE, arguments: {
              'name': selectedPlan.value!.name,
              'image': selectedNetworkProvider.value!.imageAsset,
              'amount': double.tryParse(debitAmount.toString()) ?? 0.0,
              'paymentType': 'Wallet',
              'paymentMethod': selectedPaymentMethod.value,
              'userId': phoneController.text,
              'customerName': selectedNetworkProvider.value!.name,
              'transactionId': transactionId,
              'packageName': selectedPlan.value!.name,
              'token': 'N/A',
            });
          } else {
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } finally {
      isPaying.value = false;
    }
  }
}