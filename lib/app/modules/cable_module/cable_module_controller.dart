import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/cable_module/model/cable_package_model.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class CableModuleController extends GetxController {
  final apiService = DioApiService(); // Using Get.find() is best practice
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final smartCardController = TextEditingController();

  final cableProviders = <CableProvider>[].obs;
  final selectedProvider = Rxn<CableProvider>();

  final cablePackages = <CablePackage>[].obs;
  final selectedPackage = Rxn<CablePackage>();

  // isLoadingProviders is now false by default as data is local
  final isLoadingProviders = false.obs;
  final isLoadingPackages = false.obs;
  final isPaying = false.obs;
  final isValidating = false.obs;
  final errorMessage = RxnString();
  final validatedCustomerName = RxnString();
  final validatedBouquetDetails = Rxn<Map<String, dynamic>>();

  final tabBarItems = ['1 Month', '2 Month', '3 Month', '4 Month', '5 Month'].obs;
  final selectedTab = '1 Month'.obs;

  final providerImages = {
    'DSTV': 'assets/images/dstv.jpeg',
    'GOTV': 'assets/images/gotv.png',
    'STARTIMES': 'assets/images/startimes.jpeg',
    'DEFAULT': 'assets/images/dstv.jpeg',
  };

  @override
  void onInit() {
    super.onInit();
    dev.log('CableModuleController initialized', name: 'CableModule');
    
    // Initialize the static list of providers directly
    final staticProviders = [
      CableProvider(id: 1, name: 'DSTV', code: 'DSTV'),
      CableProvider(id: 2, name: 'GOTV', code: 'GOTV'),
      CableProvider(id: 3, name: 'STARTIMES', code: 'STARTIMES'),
    ];

    cableProviders.assignAll(staticProviders);
    dev.log('Loaded ${cableProviders.length} cable providers', name: 'CableModule');

    // Automatically select the first provider and fetch its packages
    if (cableProviders.isNotEmpty) {
      onProviderSelected(cableProviders.first);
    }

    // Add listener for auto-validation
    smartCardController.addListener(() {
      // Clear the name if the user clears the input
      if (smartCardController.text.isEmpty) {
        validatedCustomerName.value = null;
        dev.log('Smart card number cleared', name: 'CableModule');
      }
      // Add a debounce to avoid calling the API on every keystroke
      debounce(
        validatedCustomerName,
        (_) {
          if (smartCardController.text.isNotEmpty && selectedProvider.value != null && validatedCustomerName.value == null) {
            dev.log('Triggering validation for smart card: ${smartCardController.text}', name: 'CableModule');
            validateSmartCard();
          }
        },
        time: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  void onClose() {
    smartCardController.dispose();
    super.onClose();
  }

  void onProviderSelected(CableProvider? provider) {
    if (provider != null && provider.id != selectedProvider.value?.id) {
      selectedProvider.value = provider;
      validatedCustomerName.value = null;
      dev.log('Provider selected: ${provider.name}', name: 'CableModule');
      fetchCablePackages(provider.code);
    }
  }

  void onTabSelected(String tabName) {
    selectedTab.value = tabName;
    dev.log('Tab selected: $tabName', name: 'CableModule');
  }

  void onPackageSelected(CablePackage? package) {
    if (package != null) {
      selectedPackage.value = package;
      dev.log('Package selected: ${package.name} - ₦${package.amount}', name: 'CableModule');
    }
  }

  Future<void> fetchCablePackages(String providerCode) async {
    try {
      isLoadingPackages.value = true;
      cablePackages.clear();
      dev.log('Fetching packages for provider: $providerCode', name: 'CableModule');
      
      final transactionUrl = box.read('transaction_service_url');
      final fullUrl = '$transactionUrl''tv/$providerCode';
      dev.log('Request URL: $fullUrl', name: 'CableModule');
      
      final result = await apiService.getJsonRequest(fullUrl);
      result.fold(
        (failure) {
          dev.log('Failed to fetch packages', name: 'CableModule', error: failure.message);
          Get.snackbar("Error", "Could not load packages: ${failure.message}");
        },
        (data) {
          final packages = (data['data'] as List)
              .map((item) => CablePackage.fromJson(item))
              .toList();
          cablePackages.assignAll(packages);
          dev.log('Loaded ${packages.length} packages', name: 'CableModule');
        },
      );
    } finally {
      isLoadingPackages.value = false;
    }
  }

  Future<void> validateSmartCard() async {
    isValidating.value = true;
    validatedCustomerName.value = null;
    validatedBouquetDetails.value = null;
    dev.log('Validating smart card: ${smartCardController.text} for provider: ${selectedProvider.value?.code}', name: 'CableModule');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found during validation', name: 'CableModule', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.");
        return;
      }

      final body = {
        "service": "tv",
        "provider": selectedProvider.value!.code.toLowerCase(),
        "number": smartCardController.text,
      };

      dev.log('Validation request body: $body', name: 'CableModule');
      final result = await apiService.postJsonRequest('$transactionUrl''validate', body);

      result.fold(
        (failure) {
          dev.log('Validation failed', name: 'CableModule', error: failure.message);
          Get.snackbar("Validation Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          dev.log('Validation response: $data', name: 'CableModule');
          if (data['success'] == 1 && data['data'] != null) {
            validatedCustomerName.value = data['data'];
            
            // Extract bouquet details from the response
            if (data['details'] != null) {
              validatedBouquetDetails.value = {
                'current_bouquet': data['details']['Current_Bouquet'] ?? 'N/A',
                'current_bouquet_price': data['details']['Current_Bouquet_Price']?.toString() ?? '0',
                'due_date': data['details']['Due_Date'] ?? 'N/A',
                'renewal_amount': data['details']['Renewal_Amount']?.toString() ?? '0',
                'status': data['details']['Status'] ?? 'Unknown',
                'customer_type': data['details']['Customer_Type'] ?? '',
                'current_bouquet_code': data['details']['Current_Bouquet_Code'] ?? 'UNKNOWN',
              };
              dev.log('Bouquet details extracted: ${validatedBouquetDetails.value}', name: 'CableModule');
            }
            
            dev.log('Smart card validated successfully: ${validatedCustomerName.value}', name: 'CableModule');
          } else {
            dev.log('Validation unsuccessful', name: 'CableModule', error: data['message']);
            Get.snackbar("Validation Failed", data['message'] ?? "Could not validate smart card.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } finally {
      isValidating.value = false;
    }
  }

  Future<void> verifyAndNavigate() async {
    dev.log('Verify and navigate initiated', name: 'CableModule');
    
    if (selectedProvider.value == null) {
      dev.log('Verification failed: No provider selected', name: 'CableModule', error: 'Provider missing');
      Get.snackbar("Error", "Please select a cable provider.");
      return;
    }

    if (smartCardController.text.isEmpty) {
      dev.log('Verification failed: No smart card number', name: 'CableModule', error: 'Smart card missing');
      Get.snackbar("Error", "Please enter your smart card number.");
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      // Validate the smart card first
      await validateSmartCard();
      
      // Check if validation was successful
      if (validatedCustomerName.value != null) {
        dev.log('Navigating to payout with: Provider=${selectedProvider.value?.name}, Customer=${validatedCustomerName.value}', name: 'CableModule');
        Get.toNamed(Routes.CABLE_PAYOUT_MODULE, arguments: {
          'provider': selectedProvider.value,
          'smartCardNumber': smartCardController.text,
          'customerName': validatedCustomerName.value,
          'bouquetDetails': validatedBouquetDetails.value,
        });
      } else {
        dev.log('Navigation cancelled: Smart card validation failed', name: 'CableModule');
      }
    }
  }

  void pay() async {
    dev.log('Payment initiated', name: 'CableModule');
    
    if (selectedProvider.value == null) {
      dev.log('Payment failed: No provider selected', name: 'CableModule', error: 'Provider missing');
      Get.snackbar("Error", "Please select a cable provider.");
      return;
    }

    if (selectedPackage.value == null) {
      dev.log('Payment failed: No package selected', name: 'CableModule', error: 'Package missing');
      Get.snackbar("Error", "Please select a package.");
      return;
    }

    if (smartCardController.text.isEmpty) {
      dev.log('Payment failed: No smart card number', name: 'CableModule', error: 'Smart card missing');
      Get.snackbar("Error", "Please enter your smart card number.");
      return;
    }

    if (validatedCustomerName.value == null) {
      dev.log('Payment failed: Smart card not validated', name: 'CableModule', error: 'Validation missing');
      Get.snackbar("Error", "Please validate your smart card number first.");
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      dev.log('Navigating to payout with: Provider=${selectedProvider.value?.name}, Package=${selectedPackage.value?.name}', name: 'CableModule');
      Get.toNamed(Routes.CABLE_PAYOUT_MODULE, arguments: {
        'provider': selectedProvider.value,
        'smartCardNumber': smartCardController.text,
        'package': selectedPackage.value,
        'customerName': validatedCustomerName.value,
      });
    }
  }
}