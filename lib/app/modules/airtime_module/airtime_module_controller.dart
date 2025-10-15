import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/airtime_module/model/airtime_provider_model.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_page.dart';
import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

class AirtimeModuleController extends GetxController {
  final apiService = ApiService();
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
    
    final verifiedNumber = Get.arguments?['verifiedNumber'];
    if (verifiedNumber != null) {
      phoneController.text = verifiedNumber;
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

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        _errorMessage.value = "Transaction URL not found. Please log in again.";
        return;
      }

      final fullUrl = transactionUrl + 'airtime';
      final result = await apiService.getJsonRequest(fullUrl);

      result.fold(
        (failure) => _errorMessage.value = failure.message,
        (data) {
          if (data['data'] != null && data['data'] is List) {
            final List<dynamic> providerListJson = data['data'];
            _airtimeProviders.value = providerListJson
                .map((item) => AirtimeProvider.fromJson(item))
                .toList();
            if (_airtimeProviders.isNotEmpty) {
              selectedProvider.value = _airtimeProviders.first;
            }
          } else {
            _errorMessage.value = "Invalid data format from server.";
          }
        },
      );
    } catch (e) {
      _errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      _isLoading.value = false;
    }
  }

  void onProviderSelected(AirtimeProvider? provider) {
    if (provider != null) {
      selectedProvider.value = provider;
    }
  }
  
  void onAmountSelected(String amount) {
      amountController.text = amount;
  }

  void pay() async {
    if (selectedProvider.value == null) {
      Get.snackbar("Error", "Please select a network provider.");
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      _isPaying.value = true;
      try {
        final transactionUrl = box.read('transaction_service_url');
        if (transactionUrl == null) {
          Get.snackbar("Error", "Transaction URL not found.");
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

        final result = await apiService.postJsonRequest('$transactionUrl''airtime', body);

        result.fold(
          (failure) {
            Get.snackbar("Payment Failed", failure.message);
          },
          (data) {
            if (data['success'] == 1 || data.containsKey('trnx_id')) {
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
              Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.");
            }
          },
        );
      } catch (e) {
        dev.log("Payment Error", error: e);
        Get.snackbar("Payment Error", "An unexpected client error occurred.");
      } finally {
        _isPaying.value = false;
      }
    }
  }
}