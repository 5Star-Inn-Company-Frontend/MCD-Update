import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/betting_module/model/betting_provider_model.dart';
import 'package:mcd/core/import/imports.dart';

class BettingModuleController extends GetxController {
  final apiService = ApiService();
  final box = GetStorage();

  final userIdController = TextEditingController();
  final amountController = TextEditingController();
  final selectedProvider = Rxn<BettingProvider>();
  final bettingProviders = <BettingProvider>[].obs;

  final isLoading = true.obs;
  final isPaying = false.obs;
  final errorMessage = RxnString();

  final validatedUserName = RxnString();

  final Map<String, String> providerImages = {
    'MYLOTTOHUB': 'assets/images/betting/MYLOTTOHUB.png',
    'CLOUDBET': 'assets/images/betting/CLOUDBET.png',
    'NAIJABET': 'assets/images/betting/NAIJABET.png',
    'BANGBET': 'assets/images/betting/BANGBET.png',
    'BETWAY': 'assets/images/betting/BETWAY.png',
    'MERRYBET': 'assets/images/betting/MERRYBET.png',
    'BETKING': 'assets/images/betting/BETKING.png',
    'BETLION': 'assets/images/betting/BETLION.png',
    'SPORTYBET': AppAsset.betting,
    'DEFAULT': 'assets/images/betting/1XBET.png',
  };

  @override
  void onInit() {
    super.onInit();
    fetchBettingProviders();

    // This will trigger validation automatically after the user stops typing.
    userIdController.addListener(() {
      // Clear the name if the user clears the input
      if (userIdController.text.isEmpty) {
        validatedUserName.value = null;
      }
      // Add a debounce to avoid calling the API on every keystroke
      debounce(
        validatedUserName,
        (_) {
          if (userIdController.text.isNotEmpty && selectedProvider.value != null) {
            validateUser();
          }
        },
        time: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  void onClose() {
    userIdController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onProviderSelected(BettingProvider? provider) {
    if (provider != null) {
      selectedProvider.value = provider;
      if (userIdController.text.isNotEmpty) {
        validateUser();
      }
    }
  }

  void onAmountSelected(String amount) {
    amountController.text = amount.replaceAll('₦', '').trim();
  }

  Future<void> fetchBettingProviders() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        errorMessage.value = "Service URL not found. Please log in again.";
        return;
      }

      final fullUrl = '$transactionUrl''betting';
      final result = await apiService.getJsonRequest(fullUrl);

      result.fold(
        (failure) => errorMessage.value = failure.message,
        (data) {
          if (data['data'] != null && data['data'] is List) {
            final List<dynamic> providersJson = data['data'];
            bettingProviders.assignAll(
              providersJson.map((item) => BettingProvider.fromJson(item)).toList(),
            );
            if (bettingProviders.isNotEmpty) {
              selectedProvider.value = bettingProviders.first;
            }
          } else {
            errorMessage.value = "No betting providers found.";
          }
        },
      );
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> validateUser() async {
    isPaying.value = true; // Use isPaying to show a loading indicator
    validatedUserName.value = null; // Clear previous name

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        Get.snackbar("Error", "Transaction URL not found.");
        return;
      }

      final body = {
        "service": "betting",
        "provider": selectedProvider.value!.code,
        "number": userIdController.text,
      };

      final result = await apiService.postJsonRequest('$transactionUrl''validate', body);

      result.fold(
        (failure) {
          Get.snackbar("Validation Failed", failure.message, backgroundColor: Colors.red, colorText: Colors.white);
        },
        (data) {
          if (data['success'] == 1 && data['data']?['name'] != null) {
            validatedUserName.value = data['data']['name'];
            Get.snackbar("Validation Successful", "User: ${validatedUserName.value}", backgroundColor: Colors.green, colorText: Colors.white);
          } else {
            Get.snackbar("Validation Failed", data['message'] ?? "Could not validate user.", backgroundColor: Colors.red, colorText: Colors.white);
          }
        },
      );
    } finally {
      isPaying.value = false;
    }
  }

  void pay() {
    isPaying.value = true;
    print("Paying with: ${selectedProvider.value?.name}, UserID: ${userIdController.text}, Amount: ${amountController.text}");
    Future.delayed(const Duration(seconds: 2), () {
      isPaying.value = false;
      Get.snackbar("Success", "Payment logic would be executed here.");
    });
  }
}