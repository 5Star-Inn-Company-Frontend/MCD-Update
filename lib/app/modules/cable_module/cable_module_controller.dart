import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/cable_module/model/cable_package_model.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/core/network/api_service.dart';

class CableModuleController extends GetxController {
  final apiService = Get.find<ApiService>(); // Using Get.find() is best practice
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final smartCardController = TextEditingController();

  final cableProviders = <CableProvider>[].obs;
  final selectedProvider = Rxn<CableProvider>();

  final cablePackages = <CablePackage>[].obs;

  // isLoadingProviders is now false by default as data is local
  final isLoadingProviders = false.obs;
  final isLoadingPackages = false.obs;
  final errorMessage = RxnString();

  final tabBarItems = ['1 Month', '2 Month', '3 Month', '4 Month', '5 Month'].obs;
  final selectedTab = '1 Month'.obs;

  final providerImages = {
    'DSTV': 'assets/images/gotv.png',
    'GOTV': 'assets/images/gotv.png',
    'STARTIMES': 'assets/images/startimes.jpeg',
    'DEFAULT': 'assets/images/default_tv.png',
  };

  @override
  void onInit() {
    super.onInit();
    
    // Initialize the static list of providers directly
    final staticProviders = [
      CableProvider(id: 1, name: 'DSTV', code: 'DSTV'),
      CableProvider(id: 2, name: 'GOTV', code: 'GOTV'),
      CableProvider(id: 3, name: 'STARTIMES', code: 'STARTIMES'),
    ];

    cableProviders.assignAll(staticProviders);

    // Automatically select the first provider and fetch its packages
    if (cableProviders.isNotEmpty) {
      onProviderSelected(cableProviders.first);
    }
  }

  @override
  void onClose() {
    smartCardController.dispose();
    super.onClose();
  }

  void onProviderSelected(CableProvider? provider) {
    if (provider != null && provider.id != selectedProvider.value?.id) {
      selectedProvider.value = provider;
      fetchCablePackages(provider.code);
    }
  }

  void onTabSelected(String tabName) {
    selectedTab.value = tabName;
  }

  Future<void> fetchCablePackages(String providerCode) async {
    try {
      isLoadingPackages.value = true;
      cablePackages.clear();
      final transactionUrl = box.read('transaction_service_url');
      final result = await apiService.getJsonRequest('$transactionUrl''tv/$providerCode');
      result.fold(
        (failure) => Get.snackbar("Error", "Could not load packages: ${failure.message}"),
        (data) {
          final packages = (data['data'] as List)
              .map((item) => CablePackage.fromJson(item))
              .toList();
          cablePackages.assignAll(packages);
        },
      );
    } finally {
      isLoadingPackages.value = false;
    }
  }

  void pay() {
    if (formKey.currentState?.validate() ?? false) {
      Get.toNamed(Routes.CABLE_PAYOUT_MODULE, arguments: {
        'provider': selectedProvider.value,
        'smartCardNumber': smartCardController.text,
        // Assuming the selected package needs to be passed, which is missing from original logic
        // 'package': selectedPackage.value, 
      });
    }
  }
}