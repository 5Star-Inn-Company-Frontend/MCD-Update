import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_module/model/cable_package_model.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class CablePayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  late final CableProvider provider;
  late final String smartCardNumber;
  late final String customerName;
  late final Map<String, dynamic>? bouquetDetails;

  final packages = <CablePackage>[].obs;
  final selectedPackage = Rxn<CablePackage>();
  final isLoadingPackages = false.obs;
  final showPackageSelection = false.obs;
  final isRenewalMode = false.obs;

  final usePoints = false.obs;
  final selectedPaymentMethod = 1.obs;
  final isPaying = false.obs;
  
  // Balance state
  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;

  // Current bouquet information from validation response
  final currentBouquet = 'N/A'.obs;
  final currentBouquetPrice = '0'.obs;
  final currentDueDate = 'N/A'.obs;
  final currentBouquetCode = 'UNKNOWN'.obs;
  final renewalAmount = '0'.obs;
  final accountStatus = 'Unknown'.obs;

  // Tab selection for package duration
  final tabBarItems = ['1 Month', '2 Month', '3 Month', '4 Month', '5 Month'].obs;
  final selectedTab = '1 Month'.obs;

  List<CablePackage> get filteredPackages {
    final monthsMap = {
      '1 Month': '1',
      '2 Month': '2',
      '3 Month': '3',
      '4 Month': '4',
      '5 Month': '5',
    };
    
    final selectedDuration = monthsMap[selectedTab.value] ?? '1';
    return packages.where((pkg) => pkg.duration == selectedDuration).toList();
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('CablePayoutController initialized', name: 'CablePayout');
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    provider = args['provider'] ?? CableProvider(id: 0, name: 'Error', code: '');
    smartCardNumber = args['smartCardNumber'] ?? '';
    customerName = args['customerName'] ?? '';
    bouquetDetails = args['bouquetDetails'];
    
    dev.log('Payout details - Provider: ${provider.name}', name: 'CablePayout');
    
    // Load bouquet information from validation response
    loadBouquetInfo();
    
    // Fetch balances
    fetchBalances();
    
    // Fetch packages for the selected provider
    fetchCablePackages(provider.code);
  }
  
  Future<void> fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'CablePayout');
      
      final result = await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances', name: 'CablePayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value = data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value = data['data']['balance']['bonus']?.toString() ?? '0';
            dev.log('Balances fetched - Wallet: ₦${walletBalance.value}, Bonus: ₦${bonusBalance.value}', name: 'CablePayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'CablePayout', error: e);
    }
  }

  void loadBouquetInfo() {
    if (bouquetDetails != null) {
      currentBouquet.value = bouquetDetails!['current_bouquet'] ?? 'N/A';
      currentBouquetPrice.value = bouquetDetails!['current_bouquet_price'] ?? '0';
      
      // Format the due date if available
      final dueDate = bouquetDetails!['due_date'] ?? 'N/A';
      if (dueDate != 'N/A' && dueDate.toString().isNotEmpty) {
        try {
          final parsedDate = DateTime.parse(dueDate);
          currentDueDate.value = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
        } catch (e) {
          currentDueDate.value = dueDate.toString();
        }
      } else {
        currentDueDate.value = 'N/A';
      }
      
      renewalAmount.value = bouquetDetails!['renewal_amount'] ?? '0';
      accountStatus.value = bouquetDetails!['status'] ?? 'Unknown';
      currentBouquetCode.value = bouquetDetails!['current_bouquet_code'] ?? 'UNKNOWN';

      dev.log('Loaded bouquet info - Name: ${currentBouquet.value}, Price: ₦${currentBouquetPrice.value}, Due: ${currentDueDate.value}, Status: ${accountStatus.value}', name: 'CablePayout');
    } else {
      dev.log('No bouquet details available', name: 'CablePayout');
    }
  }

  Future<void> fetchCablePackages(String providerCode) async {
    try {
      isLoadingPackages.value = true;
      packages.clear();
      dev.log('Fetching packages for provider: $providerCode', name: 'CablePayout');
      
      final transactionUrl = box.read('transaction_service_url');
      final fullUrl = '$transactionUrl''tv/$providerCode';
      dev.log('Request URL: $fullUrl', name: 'CablePayout');
      
      final result = await apiService.getrequest(fullUrl);
      result.fold(
        (failure) {
          dev.log('Failed to fetch packages', name: 'CablePayout', error: failure.message);
          Get.snackbar("Error", "Could not load packages: ${failure.message}", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          final fetchedPackages = (data['data'] as List)
              .map((item) => CablePackage.fromJson(item))
              .toList();
          packages.assignAll(fetchedPackages);
          dev.log('Loaded ${fetchedPackages.length} packages', name: 'CablePayout');
        },
      );
    } finally {
      isLoadingPackages.value = false;
    }
  }

  void onTabSelected(String tabName) {
    selectedTab.value = tabName;
    selectedPackage.value = null; // Clear selection when tab changes
    dev.log('Tab selected: $tabName', name: 'CablePayout');
  }

  void onPackageSelected(CablePackage? package) {
    if (package != null) {
      selectedPackage.value = package;
      dev.log('Package selected: ${package.name} - ₦${package.amount}', name: 'CablePayout');
    }
  }

  void toggleUsePoints(bool value) {
    usePoints.value = value;
    dev.log('Use points toggled: $value', name: 'CablePayout');
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: ${value == 1 ? "Wallet" : "Mega Bonus"}', name: 'CablePayout');
    }
  }

  void onRenewTapped() {
    if (currentBouquet.value == 'N/A' || currentBouquetCode.value == 'UNKNOWN') {
      Get.snackbar("Error", "No active bouquet to renew. Please select a new bouquet.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    isRenewalMode.value = true;
    showPackageSelection.value = false;
    selectedPackage.value = null;
    dev.log('Renew mode activated for bouquet: ${currentBouquet.value}', name: 'CablePayout');
  }

  void onNewBouquetTapped() {
    isRenewalMode.value = false;
    showPackageSelection.value = true;
    selectedPackage.value = null;
    dev.log('New bouquet mode activated', name: 'CablePayout');
  }

  void confirmAndPay() async {
    // Validation
    if (isRenewalMode.value) {
      // For renewal, we use the current bouquet information
      if (currentBouquetCode.value == 'UNKNOWN') {
        Get.snackbar("Error", "Cannot renew. Invalid bouquet information.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }
      dev.log('Processing renewal for current bouquet: ${currentBouquet.value}', name: 'CablePayout');
    } else if (!showPackageSelection.value || selectedPackage.value == null) {
      dev.log('Payment failed: No package selected', name: 'CablePayout', error: 'Package missing');
      Get.snackbar("Error", "Please select a package.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    isPaying.value = true;
    
    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'CablePayout', error: 'URL missing');
        Get.snackbar("Error", "Transaction URL not found.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final username = box.read('biometric_username') ?? 'UN';
      final userPrefix = username.length >= 2 ? username.substring(0, 2).toUpperCase() : username.toUpperCase();
      final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

      // Determine the package code to use
      String packageCode;
      String packageName;
      String packageAmount;

      if (isRenewalMode.value) {
        // For renewal, use the current bouquet code and renewal amount
        packageCode = currentBouquetCode.value;
        packageName = currentBouquet.value;
        packageAmount = renewalAmount.value;
      } else {
        packageCode = selectedPackage.value!.code;
        packageName = selectedPackage.value!.name;
        packageAmount = selectedPackage.value!.amount;
      }

      final body = {
        "coded": packageCode,
        "number": smartCardNumber,
        "payment": selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
        "promo": "0",
        "ref": ref,
      };

      dev.log('Payment request body: $body', name: 'CablePayout');
      final result = await apiService.postrequest('$transactionUrl''tv', body);

      result.fold(
        (failure) {
          dev.log('Payment failed', name: 'CablePayout', error: failure.message);
          Get.snackbar("Payment Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          dev.log('Payment response: $data', name: 'CablePayout');
          if (data['success'] == 1 || data.containsKey('trnx_id')) {
            dev.log('Payment successful. Transaction ID: ${data['trnx_id']}', name: 'CablePayout');
            
            Get.snackbar("Success", data['message'] ?? "Cable subscription successful!", backgroundColor: Colors.green, colorText: Colors.white);

            final selectedImage = Get.find<CableModuleController>().providerImages[provider.name] ?? 
                                   Get.find<CableModuleController>().providerImages['DEFAULT']!;

            Get.offAllNamed(
              Routes.CABLE_TRANSACTION_MODULE,
              arguments: {
                'providerName': provider.name,
                'image': selectedImage,
                'amount': double.tryParse(packageAmount) ?? 0.0,
                'paymentType': "Cable TV",
                'userId': smartCardNumber,
                'customerName': customerName,
                'transactionId': data['trnx_id']?.toString() ?? ref,
                'packageName': packageName,
                'isRenewal': isRenewalMode.value,
              },
            );
          } else {
            dev.log('Payment unsuccessful', name: 'CablePayout', error: data['message']);
            Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } catch (e) {
      dev.log("Payment Error", name: 'CablePayout', error: e);
      Get.snackbar("Payment Error", "An unexpected client error occurred.", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isPaying.value = false;
    }
  }
}