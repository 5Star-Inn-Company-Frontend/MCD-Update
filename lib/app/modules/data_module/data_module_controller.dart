import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/modules/data_module/model/data_plan_model.dart';
import 'package:mcd/app/modules/data_module/network_provider.dart';
import 'package:mcd/core/network/api_service.dart';

class DataModuleController extends GetxController {
  final apiService = ApiService();
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

  @override
  void onInit() {
    super.onInit();
    final verifiedNumber = Get.arguments?['verifiedNumber'];
    if (verifiedNumber != null) {
      phoneController.text = verifiedNumber;
    }
    networkProviders.value = NetworkProvider.all;
    if (networkProviders.isNotEmpty) {
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
      final result = await apiService.getJsonRequest('$transactionUrl''data/$networkName');
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
      Get.snackbar("Error", "Please select a data plan to purchase.");
      return;
    }

    isPaying.value = true;
    try {
      final transactionUrl = box.read('transaction_service_url');
      final ref = 'mcd_${DateTime.now().millisecondsSinceEpoch}';

      final body = {
        "coded": selectedPlan.value!.coded,
        "number": phoneController.text,
        "payment": "wallet",
        "promo": "0",
        "ref": ref,
        "country": "NG"
      };

      final result = await apiService.postJsonRequest('$transactionUrl''data', body);

      result.fold(
        (failure) {
          Get.snackbar("Payment Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          if (data['success'] == 1) {
            Get.snackbar("Success", data['message'] ?? "Data purchase successful!", backgroundColor: Colors.green, colorText: Colors.white);
            // Navigate to transaction details screen on success
            Get.toNamed(Routes.TRANSACTION_DETAIL_MODULE, arguments: {
              'name': selectedPlan.value!.name,
              'image': selectedNetworkProvider.value!.imageAsset,
              'amount': double.tryParse(selectedPlan.value!.price) ?? 0.0,
              'paymentType': 'Data'
            });
          } else {
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } finally {
      isPaying.value = false;
    }
  }
}