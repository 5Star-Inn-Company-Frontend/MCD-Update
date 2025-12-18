import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/airtime_module/model/airtime_provider_model.dart';
import 'package:mcd/app/modules/general_payout/general_payout_controller.dart';
import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class AirtimeModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  final selectedProvider = Rxn<AirtimeProvider>();

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final _errorMessage = RxnString();
  String? get errorMessage => _errorMessage.value;

  final _airtimeProviders = <AirtimeProvider>[].obs;
  List<AirtimeProvider> get airtimeProviders => _airtimeProviders;

  final _isPaying = false.obs;
  bool get isPaying => _isPaying.value;
  
  // Tab switcher state
  final isSingleAirtime = true.obs;
  
  // Multiple airtime list
  final multipleAirtimeList = <Map<String, dynamic>>[].obs;
  
  final Map<String, String> networkImages = {
    'mtn': 'assets/images/mtn.png',
    'airtel': 'assets/images/airtel.png',
    'glo': 'assets/images/glo.png',       
    '9mobile': 'assets/images/etisalat.png', 
  };

  @override
  void onInit() {
    super.onInit();
    // Check if we have a verified number and network from navigation
    final verifiedNumber = Get.arguments?['verifiedNumber'];
    final verifiedNetwork = Get.arguments?['verifiedNetwork'];
    
    if (verifiedNumber != null) {
      phoneController.text = verifiedNumber;
      dev.log('Airtime initialized with verified number: $verifiedNumber', name: 'AirtimeModule');
    }
    
    if (verifiedNetwork != null) {
      dev.log('Airtime initialized with verified network: $verifiedNetwork', name: 'AirtimeModule');
    }
    
    fetchAirtimeProviders(preSelectedNetwork: verifiedNetwork);
  }

  @override
  void onClose() {
    phoneController.dispose();
    amountController.dispose();
    super.onClose();
  }


  Future<void> fetchAirtimeProviders({String? preSelectedNetwork}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;
      dev.log('Fetching airtime providers...', name: 'AirtimeModule');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        _errorMessage.value = "Transaction URL not found. Please log in again.";
        dev.log('Transaction URL not found', name: 'AirtimeModule', error: _errorMessage.value);
        return;
      }

      final fullUrl = transactionUrl + 'airtime';
      dev.log('Request URL: $fullUrl', name: 'AirtimeModule');
      final result = await apiService.getrequest(fullUrl);

      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
          dev.log('Failed to fetch providers', name: 'AirtimeModule', error: failure.message);
        },
        (data) {
          dev.log('Providers fetched successfully', name: 'AirtimeModule');
          if (data['data'] != null && data['data'] is List) {
            final List<dynamic> providerListJson = data['data'];
            _airtimeProviders.value = providerListJson
                .map((item) => AirtimeProvider.fromJson(item))
                .toList();
            dev.log('Loaded ${_airtimeProviders.length} providers', name: 'AirtimeModule');
            
            // Pre-select network if provided from verification
            if (preSelectedNetwork != null && _airtimeProviders.isNotEmpty) {
              dev.log('Trying to match network: "$preSelectedNetwork"', name: 'AirtimeModule');
              dev.log('Available providers: ${_airtimeProviders.map((p) => p.network).join(", ")}', name: 'AirtimeModule');
              
              // Normalize the network name for matching
              final normalizedInput = _normalizeNetworkName(preSelectedNetwork);
              dev.log('Normalized input: "$normalizedInput"', name: 'AirtimeModule');
              
              final matchedProvider = _airtimeProviders.firstWhereOrNull(
                (provider) => _normalizeNetworkName(provider.network) == normalizedInput
              );
              
              if (matchedProvider != null) {
                selectedProvider.value = matchedProvider;
                dev.log('✅ Pre-selected verified network: ${matchedProvider.network}', name: 'AirtimeModule');
              } else {
                selectedProvider.value = _airtimeProviders.first;
                dev.log('❌ Network "$preSelectedNetwork" not found in providers, auto-selected first: ${selectedProvider.value?.network}', name: 'AirtimeModule');
              }
            } else if (_airtimeProviders.isNotEmpty) {
              selectedProvider.value = _airtimeProviders.first;
              dev.log('Auto-selected provider: ${selectedProvider.value?.network}', name: 'AirtimeModule');
            }
          } else {
            _errorMessage.value = "Invalid data format from server.";
            dev.log('Invalid data format', name: 'AirtimeModule', error: _errorMessage.value);
          }
        },
      );
    } catch (e) {
      _errorMessage.value = "An unexpected error occurred: $e";
      dev.log("Error fetching providers", name: 'AirtimeModule', error: e);
    } finally {
      _isLoading.value = false;
    }
  }

  void onProviderSelected(AirtimeProvider? provider) {
    if (provider != null) {
      selectedProvider.value = provider;
      dev.log('Provider selected: ${provider.network}', name: 'AirtimeModule');
    }
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
  
  void onAmountSelected(String amount) {
      amountController.text = amount;
      dev.log('Amount selected: ₦$amount', name: 'AirtimeModule');
  }
  
  // void setPaymentMethod(String method) {
  //   dev.log('Setting payment method: $method', name: 'AirtimeModule');
  //   selectedPaymentMethod.value = method;
  // }

  void pay() async {
    dev.log('Navigating to payout screen', name: 'AirtimeModule');
    
    if (selectedProvider.value == null) {
      dev.log('Navigation failed: No provider selected', name: 'AirtimeModule', error: 'Provider missing');
      Get.snackbar("Error", "Please select a network provider.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      final selectedImage = networkImages[selectedProvider.value!.network.toLowerCase()] ?? AppAsset.mtn;
      
      Get.toNamed(
        Routes.GENERAL_PAYOUT,
        arguments: {
          'paymentType': PaymentType.airtime,
          'paymentData': {
            'provider': selectedProvider.value,
            'phoneNumber': phoneController.text,
            'amount': amountController.text,
            'networkImage': selectedImage,
          },
        },
      );
    }
  }
  
  // Multiple airtime methods
  void addToMultipleList() {
    if (selectedProvider.value == null) {
      Get.snackbar("Error", "Please select a network provider.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    if (phoneController.text.isEmpty || phoneController.text.length != 11) {
      Get.snackbar("Error", "Please enter a valid 11-digit phone number.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter an amount.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    // Check if we can add more (max 5)
    if (multipleAirtimeList.length >= 5) {
      Get.snackbar("Limit Reached", "You can only add up to 5 numbers.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    final selectedImage = networkImages[selectedProvider.value!.network.toLowerCase()] ?? AppAsset.mtn;
    
    multipleAirtimeList.add({
      'provider': selectedProvider.value,
      'phoneNumber': phoneController.text,
      'amount': amountController.text,
      'networkImage': selectedImage,
    });
    
    dev.log('Added to multiple list: ${phoneController.text} - ₦${amountController.text}', name: 'AirtimeModule');
    
    // Clear inputs for next entry
    phoneController.clear();
    amountController.clear();
    
    Get.snackbar(
      "Added",
      "${multipleAirtimeList.last['phoneNumber']} - ₦${multipleAirtimeList.last['amount']}",
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      colorText: AppColors.primaryColor,
      duration: const Duration(seconds: 2),
    );
  }
  
  void removeFromMultipleList(int index) {
    if (index >= 0 && index < multipleAirtimeList.length) {
      dev.log('Removing from multiple list: ${multipleAirtimeList[index]['phoneNumber']}', name: 'AirtimeModule');
      multipleAirtimeList.removeAt(index);
    }
  }
  
  void payMultiple() async {
    if (multipleAirtimeList.isEmpty) {
      Get.snackbar("Error", "Please add at least one number to the list.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }
    
    dev.log('Navigating to multiple airtime payout with ${multipleAirtimeList.length} numbers', name: 'AirtimeModule');
    
    Get.toNamed(
      Routes.GENERAL_PAYOUT,
      arguments: {
        'paymentType': PaymentType.airtime,
        'paymentData': {
          'isMultiple': true,
          'multipleList': multipleAirtimeList.toList(),
        },
      },
    );
  }
}