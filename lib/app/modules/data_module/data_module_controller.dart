import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/modules/data_module/model/data_plan_model.dart';
import 'package:mcd/app/modules/data_module/network_provider.dart';
import 'package:mcd/app/modules/general_payout/general_payout_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

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
        dev.log('Pre-selected verified network: ${matchedProvider.name}');
      } else {
        onNetworkSelected(networkProviders.first);
        dev.log('Network "$verifiedNetwork" not found, auto-selected first: ${networkProviders.first.name}');
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

  Future<void> pickContact() async {
    try {
      final permissionStatus = await Permission.contacts.request();
      
      if (permissionStatus.isGranted) {
        final contact = await FlutterContacts.openExternalPick();
        
        if (contact != null) {
          final fullContact = await FlutterContacts.getContact(contact.id);
          
          if (fullContact != null && fullContact.phones.isNotEmpty) {
            String phoneNumber = fullContact.phones.first.number;            
            phoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
            
            if (phoneNumber.startsWith('234')) {
              phoneNumber = '0${phoneNumber.substring(3)}';
            } else if (phoneNumber.startsWith('+234')) {
              phoneNumber = '0${phoneNumber.substring(4)}';
            } else if (!phoneNumber.startsWith('0') && phoneNumber.length == 10) {
              phoneNumber = '0$phoneNumber';
            }
            
            if (phoneNumber.length == 11) {
              phoneController.text = phoneNumber;
              dev.log('Selected contact number: $phoneNumber', name: 'DataModule');
            } else {
              Get.snackbar(
                'Invalid Number',
                'The selected contact does not have a valid Nigerian phone number',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            }
          } else {
            Get.snackbar(
              'No Phone Number',
              'The selected contact does not have a phone number',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        }
      } else if (permissionStatus.isPermanentlyDenied) {
        Get.snackbar(
          'Permission Denied',
          'Please enable contacts permission in settings',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        await openAppSettings();
      } else {
        Get.snackbar(
          'Permission Required',
          'Contacts permission is required to select a contact',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      dev.log('Error picking contact', name: 'DataModule', error: e);
      Get.snackbar(
        'Error',
        'Failed to pick contact. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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

    if (selectedNetworkProvider.value == null) {
      Get.snackbar("Error", "Network provider is not selected.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    Get.toNamed(
      Routes.GENERAL_PAYOUT,
      arguments: {
        'paymentType': PaymentType.data,
        'paymentData': {
          'networkProvider': selectedNetworkProvider.value,
          'dataPlan': selectedPlan.value,
          'phoneNumber': phoneController.text,
          'networkImage': selectedNetworkProvider.value!.imageAsset,
        },
      },
    );
  }
}