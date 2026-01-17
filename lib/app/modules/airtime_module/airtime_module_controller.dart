import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/airtime_module/model/airtime_provider_model.dart';
import 'package:mcd/app/modules/general_payout/general_payout_controller.dart';
import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

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
      dev.log('Airtime initialized with verified number: $verifiedNumber',
          name: 'AirtimeModule');
    }

    if (verifiedNetwork != null) {
      dev.log('Airtime initialized with verified network: $verifiedNetwork',
          name: 'AirtimeModule');
    }

    fetchAirtimeProviders(preSelectedNetwork: verifiedNetwork);
  }

  @override
  void onClose() {
    phoneController.dispose();
    amountController.dispose();
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
            } else if (!phoneNumber.startsWith('0') &&
                phoneNumber.length == 10) {
              phoneNumber = '0$phoneNumber';
            }

            if (phoneNumber.length == 11) {
              phoneController.text = phoneNumber;
              dev.log('Selected contact number: $phoneNumber',
                  name: 'AirtimeModule');

              // auto-detect network from phone prefix
              final detectedNetwork = _detectNetworkFromNumber(phoneNumber);
              if (detectedNetwork != null && _airtimeProviders.isNotEmpty) {
                final matchedProvider = _airtimeProviders.firstWhereOrNull(
                    (provider) =>
                        _normalizeNetworkName(provider.network) ==
                        detectedNetwork);
                if (matchedProvider != null) {
                  selectedProvider.value = matchedProvider;
                  dev.log('Auto-selected network: $detectedNetwork',
                      name: 'AirtimeModule');
                }
              }
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
      dev.log('Error picking contact', name: 'AirtimeModule', error: e);
      Get.snackbar(
        'Error',
        'Failed to pick contact. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchAirtimeProviders({String? preSelectedNetwork}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;
      dev.log('Fetching airtime providers...', name: 'AirtimeModule');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null || transactionUrl.isEmpty) {
        _errorMessage.value = "Transaction URL not found. Please log in again.";
        dev.log('Transaction URL not found',
            name: 'AirtimeModule', error: _errorMessage.value);
        return;
      }

      final fullUrl = transactionUrl + 'airtime';
      dev.log('Request URL: $fullUrl', name: 'AirtimeModule');
      final result = await apiService.getrequest(fullUrl);

      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
          dev.log('Failed to fetch providers',
              name: 'AirtimeModule', error: failure.message);
        },
        (data) {
          dev.log('Providers fetched successfully', name: 'AirtimeModule');
          if (data['data'] != null && data['data'] is List) {
            final List<dynamic> providerListJson = data['data'];
            _airtimeProviders.value = providerListJson
                .map((item) => AirtimeProvider.fromJson(item))
                .toList();
            dev.log('Loaded ${_airtimeProviders.length} providers',
                name: 'AirtimeModule');

            // Pre-select network if provided from verification
            if (preSelectedNetwork != null && _airtimeProviders.isNotEmpty) {
              dev.log('Trying to match network: "$preSelectedNetwork"',
                  name: 'AirtimeModule');
              dev.log(
                  'Available providers: ${_airtimeProviders.map((p) => p.network).join(", ")}',
                  name: 'AirtimeModule');

              // Normalize the network name for matching
              final normalizedInput = _normalizeNetworkName(preSelectedNetwork);
              dev.log('Normalized input: "$normalizedInput"',
                  name: 'AirtimeModule');

              final matchedProvider = _airtimeProviders.firstWhereOrNull(
                  (provider) =>
                      _normalizeNetworkName(provider.network) ==
                      normalizedInput);

              if (matchedProvider != null) {
                selectedProvider.value = matchedProvider;
                dev.log(
                    'Pre-selected verified network: ${matchedProvider.network}',
                    name: 'AirtimeModule');
              } else {
                selectedProvider.value = _airtimeProviders.first;
                dev.log(
                    'Network "$preSelectedNetwork" not found in providers, auto-selected first: ${selectedProvider.value?.network}',
                    name: 'AirtimeModule');
              }
            } else if (_airtimeProviders.isNotEmpty) {
              selectedProvider.value = _airtimeProviders.first;
              dev.log(
                  'Auto-selected provider: ${selectedProvider.value?.network}',
                  name: 'AirtimeModule');
            }
          } else {
            _errorMessage.value = "Invalid data format from server.";
            dev.log('Invalid data format',
                name: 'AirtimeModule', error: _errorMessage.value);
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

  /// detect network from nigerian phone prefix
  String? _detectNetworkFromNumber(String phoneNumber) {
    if (phoneNumber.length < 4) return null;

    final prefix = phoneNumber.substring(0, 4);

    // mtn prefixes
    const mtnPrefixes = [
      '0703',
      '0706',
      '0803',
      '0806',
      '0810',
      '0813',
      '0814',
      '0816',
      '0903',
      '0906',
      '0913',
      '0916'
    ];
    if (mtnPrefixes.contains(prefix)) return 'mtn';

    // airtel prefixes
    const airtelPrefixes = [
      '0701',
      '0708',
      '0802',
      '0808',
      '0812',
      '0902',
      '0907',
      '0912',
      '0901'
    ];
    if (airtelPrefixes.contains(prefix)) return 'airtel';

    // glo prefixes
    const gloPrefixes = ['0705', '0805', '0807', '0811', '0905', '0915'];
    if (gloPrefixes.contains(prefix)) return 'glo';

    // 9mobile prefixes
    const nmobilePrefixes = ['0809', '0817', '0818', '0909', '0908'];
    if (nmobilePrefixes.contains(prefix)) return '9mobile';

    return null;
  }

  /// Normalize network name for consistent matching
  String _normalizeNetworkName(String networkName) {
    final normalized = networkName.toLowerCase().trim();

    // Handle common variations
    if (normalized.contains('mtn')) return 'mtn';
    if (normalized.contains('airtel')) return 'airtel';
    if (normalized.contains('glo')) return 'glo';
    if (normalized.contains('9mobile') ||
        normalized.contains('etisalat') ||
        normalized == '9mob') return '9mobile';

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
      dev.log('Navigation failed: No provider selected',
          name: 'AirtimeModule', error: 'Provider missing');
      Get.snackbar("Error", "Please select a network provider.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      final selectedImage =
          networkImages[selectedProvider.value!.network.toLowerCase()] ??
              AppAsset.mtn;

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
  void addToMultipleList() async {
    if (selectedProvider.value == null) {
      Get.snackbar("Error", "Please select a network provider.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    if (phoneController.text.isEmpty || phoneController.text.length != 11) {
      Get.snackbar("Error", "Please enter a valid 11-digit phone number.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Please enter an amount.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    // Check if we can add more (max 5)
    if (multipleAirtimeList.length >= 5) {
      Get.snackbar("Limit Reached", "You can only add up to 5 numbers.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    // Store current values before verification
    final phoneToVerify = phoneController.text;
    final amountToAdd = amountController.text;
    final providerToAdd = selectedProvider.value;

    dev.log('Navigating to verification for: $phoneToVerify',
        name: 'AirtimeModule');

    // Navigate to number verification
    final result =
        await Get.toNamed(Routes.NUMBER_VERIFICATION_MODULE, arguments: {
      'redirectTo': Routes.AIRTIME_MODULE,
      'isMultipleAirtimeAdd': true,
      'phoneNumber': phoneToVerify,
    });

    // Check if verification was successful and returned data
    if (result != null && result is Map<String, dynamic>) {
      final verifiedNumber = result['verifiedNumber'];
      final verifiedNetwork = result['verifiedNetwork'];

      if (verifiedNumber != null && verifiedNetwork != null) {
        dev.log('Number verified: $verifiedNumber as $verifiedNetwork',
            name: 'AirtimeModule');

        // Use the verified network name to get the correct logo
        final normalizedNetwork = _normalizeNetworkName(verifiedNetwork);
        final selectedImage = networkImages[normalizedNetwork] ?? AppAsset.mtn;

        dev.log(
            'Using network image for: $normalizedNetwork (verified as: $verifiedNetwork)',
            name: 'AirtimeModule');

        // Find the matching provider based on verified network
        final matchedProvider = _airtimeProviders.firstWhereOrNull((provider) =>
                _normalizeNetworkName(provider.network) == normalizedNetwork) ??
            providerToAdd;

        multipleAirtimeList.add({
          'provider': matchedProvider,
          'phoneNumber': verifiedNumber,
          'amount': amountToAdd,
          'networkImage': selectedImage,
        });

        dev.log('Added to multiple list: $verifiedNumber - ₦$amountToAdd',
            name: 'AirtimeModule');

        // Clear inputs for next entry
        phoneController.clear();
        amountController.clear();

        Get.snackbar(
          "Added",
          "$verifiedNumber - ₦$amountToAdd",
          backgroundColor: AppColors.successBgColor,
          colorText: AppColors.textSnackbarColor,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      dev.log('Verification cancelled or failed', name: 'AirtimeModule');
    }
  }

  void removeFromMultipleList(int index) {
    if (index >= 0 && index < multipleAirtimeList.length) {
      dev.log(
          'Removing from multiple list: ${multipleAirtimeList[index]['phoneNumber']}',
          name: 'AirtimeModule');
      multipleAirtimeList.removeAt(index);
    }
  }

  void payMultiple() async {
    if (multipleAirtimeList.isEmpty) {
      Get.snackbar("Error", "Please add at least one number to the list.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    dev.log(
        'Navigating to multiple airtime payout with ${multipleAirtimeList.length} numbers',
        name: 'AirtimeModule');

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
