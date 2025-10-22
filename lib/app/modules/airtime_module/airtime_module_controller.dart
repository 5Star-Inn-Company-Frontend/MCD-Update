import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/airtime_module/model/airtime_provider_model.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_page.dart';
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
  
  final Map<String, String> networkImages = {
    'mtn': 'assets/images/mtn.png',
    'airtel': 'assets/images/airtel.png',
    'glo': 'assets/images/glo.png',       
    '9mobile': 'assets/images/etisalat.png', 
  };

  @override
  void onInit() {
    super.onInit();
    dev.log('AirtimeModuleController initialized', name: 'AirtimeModule');
    
    final verifiedNumber = Get.arguments?['verifiedNumber'];
    if (verifiedNumber != null) {
      phoneController.text = verifiedNumber;
      dev.log('Pre-filled phone number: $verifiedNumber', name: 'AirtimeModule');
    }

    fetchAirtimeProviders();
  }

  @override
  void onClose() {
    phoneController.dispose();
    amountController.dispose();
    super.onClose();
  }


  Future<void> fetchAirtimeProviders() async {
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
      final result = await apiService.getJsonRequest(fullUrl);

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
            if (_airtimeProviders.isNotEmpty) {
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
  
  void onAmountSelected(String amount) {
      amountController.text = amount;
      dev.log('Amount selected: ₦$amount', name: 'AirtimeModule');
  }

  void pay() async {
    dev.log('Payment initiated', name: 'AirtimeModule');
    
    if (selectedProvider.value == null) {
      dev.log('Payment failed: No provider selected', name: 'AirtimeModule', error: 'Provider missing');
      Get.snackbar("Error", "Please select a network provider.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      _isPaying.value = true;
      try {
        final transactionUrl = box.read('transaction_service_url');
        if (transactionUrl == null) {
          dev.log('Transaction URL not found', name: 'AirtimeModule', error: 'URL missing');
          Get.snackbar("Error", "Transaction URL not found.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          return;
        }

        final ref = 'mcd_${DateTime.now().millisecondsSinceEpoch}';

        final body = {
          "provider": selectedProvider.value!.network.toUpperCase(),
          "amount": amountController.text,
          "number": phoneController.text,
          "country": "NG",
          "payment": "wallet",
          "promo": "0",
          "ref": ref,
          "operatorID": int.tryParse(selectedProvider.value!.server) ?? 0,
        };

        dev.log('Payment request body: $body', name: 'AirtimeModule');
        final result = await apiService.postJsonRequest('$transactionUrl''airtime', body);

        result.fold(
          (failure) {
            dev.log('Payment failed', name: 'AirtimeModule', error: failure.message);
            Get.snackbar("Payment Failed", failure.message, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          },
          (data) {
            dev.log('Payment response: $data', name: 'AirtimeModule');
            if (data['success'] == 1 || data.containsKey('trnx_id')) {
              dev.log('Payment successful. Transaction ID: ${data['trnx_id']}', name: 'AirtimeModule');
              Get.snackbar("Success", data['message'] ?? "Airtime purchase successful!",);

              final selectedImage = networkImages[selectedProvider.value!.network.toLowerCase()] ?? AppAsset.mtn;
              
              Get.to(
                () => TransactionDetailModulePage(),
                arguments: {
                  'name': "Airtime Top Up",
                  'image': selectedImage,
                  'amount': double.tryParse(amountController.text) ?? 0.0,
                  'paymentType': "Airtime"
                },
              );
            } else {
              dev.log('Payment unsuccessful', name: 'AirtimeModule', error: data['message']);
              Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.");
            }
          },
        );
      } catch (e) {
        dev.log("Payment Error", name: 'AirtimeModule', error: e);
        Get.snackbar("Payment Error", "An unexpected client error occurred.");
      } finally {
        _isPaying.value = false;
      }
    }
  }
}