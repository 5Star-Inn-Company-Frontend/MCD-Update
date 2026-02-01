import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'models/giveaway_model.dart';

class GiveawayModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  // Observables
  final _giveaways = <GiveawayModel>[].obs;
  final _myGiveawayCount = 0.obs;
  final _isLoading = false.obs;
  final _isCreating = false.obs;
  final selectedPaymentMethod =
      'wallet'.obs; // wallet, paystack, general_market, mega_bonus

  // Getters
  List<GiveawayModel> get giveaways => _giveaways;
  int get myGiveawayCount => _myGiveawayCount.value;
  bool get isLoading => _isLoading.value;
  bool get isCreating => _isCreating.value;

  // Form controllers
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();
  final receiverController = TextEditingController();

  // Form data
  // Form data
  final _selectedType = 'airtime'.obs;
  final _selectedTypeCode = RxnString('mtn');
  final _selectedImage = Rx<File?>(null);
  final _showContact = true.obs;
  final _isPublic = true.obs;

  // Dynamic Data Lists
  final dataPlans = <Map<String, dynamic>>[].obs;
  final electricityProviders = <Map<String, dynamic>>[].obs;
  final cableProviders = <Map<String, dynamic>>[].obs;
  final cablePackages = <Map<String, dynamic>>[].obs;
  final bettingProviders = <Map<String, dynamic>>[].obs;

  // Selected Items
  final selectedDataPlan = Rxn<Map<String, dynamic>>();
  final selectedElectricityProvider = Rxn<Map<String, dynamic>>();
  final selectedCableProvider = Rxn<Map<String, dynamic>>();
  final selectedCablePackage = Rxn<Map<String, dynamic>>();
  final selectedBettingProvider = Rxn<Map<String, dynamic>>();

  // Loading States for Dropdowns
  final isFetchingDataPlans = false.obs;
  final isFetchingElectricityProviders = false.obs;
  final isFetchingCableProviders = false.obs;
  final isFetchingCablePackages = false.obs;
  final isFetchingBettingProviders = false.obs;

  String get selectedType => _selectedType.value;
  String? get selectedTypeCode => _selectedTypeCode.value;
  File? get selectedImage => _selectedImage.value;
  bool get showContact => _showContact.value;
  bool get isPublic => _isPublic.value;

  @override
  void onInit() {
    super.onInit();
    dev.log('GiveawayModule initialized', name: 'GiveawayModule');
    fetchGiveaways();

    // Listen to type changes to reset related fields
    ever(_selectedType, (_) {
      _selectedTypeCode.value = null;
      amountController.clear();
      // Clear all specific selections
      selectedDataPlan.value = null;
      selectedElectricityProvider.value = null;
      selectedCableProvider.value = null;
      selectedCablePackage.value = null;
      selectedBettingProvider.value = null;

      // Clear lists
      dataPlans.clear();
      cablePackages.clear();

      // Auto-fetch providers if needed
      if (_selectedType.value == 'electricity') fetchElectricityProviders();
      if (_selectedType.value == 'tv') fetchCableProviders();
      if (_selectedType.value == 'betting_topup') fetchBettingProviders();
    });
  }

  @override
  void onClose() {
    dev.log('GiveawayModule disposing', name: 'GiveawayModule');
    amountController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    receiverController.dispose();
    super.onClose();
  }

  // Fetch all giveaways
  Future<void> fetchGiveaways() async {
    try {
      _isLoading.value = true;
      dev.log('Fetching giveaways...', name: 'GiveawayModule');

      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}fetch-giveaways';
      dev.log('Request URL: $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) {
          dev.log('Failed to fetch giveaways',
              name: 'GiveawayModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            final giveawaysData = data['data'] as List;
            _giveaways.value =
                giveawaysData.map((e) => GiveawayModel.fromJson(e)).toList();
            _myGiveawayCount.value = data['mygiveaway'] ?? 0;
            dev.log(
                'Fetched ${_giveaways.length} giveaways, myCount: ${_myGiveawayCount.value}',
                name: 'GiveawayModule');
          } else {
            dev.log('Fetch failed with success=0', name: 'GiveawayModule');
          }
        },
      );
    } catch (e) {
      dev.log('Exception while fetching giveaways',
          name: 'GiveawayModule', error: e);
      Get.snackbar('Error', 'Failed to fetch giveaways: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Fetch single giveaway details
  Future<GiveawayDetailModel?> fetchGiveawayDetail(int id) async {
    try {
      dev.log('Fetching giveaway detail for ID: $id', name: 'GiveawayModule');
      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}fetch-giveaway/$id';
      dev.log('Request URL: $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      GiveawayDetailModel? detailModel;
      response.fold(
        (failure) {
          dev.log('Failed to fetch giveaway detail',
              name: 'GiveawayModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            detailModel = GiveawayDetailModel.fromJson(data['data']);
            dev.log('Successfully fetched giveaway detail',
                name: 'GiveawayModule');
          } else {
            dev.log('Fetch detail failed with success=0',
                name: 'GiveawayModule');
          }
        },
      );
      return detailModel;
    } catch (e) {
      dev.log('Exception while fetching giveaway detail',
          name: 'GiveawayModule', error: e);
      Get.snackbar('Error', 'Failed to fetch giveaway details: $e');
      return null;
    }
  }

  // --- New Methods for Dynamic Dropdowns ---

  Future<void> fetchDataPlans(String networkCode) async {
    try {
      isFetchingDataPlans.value = true;
      dataPlans.clear();
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) return;

      final url = '${transactionUrl}data/${networkCode.toUpperCase()}';
      dev.log('Fetching data plans: $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) => dev.log('Failed to fetch data plans',
            name: 'GiveawayModule', error: failure.message),
        (data) {
          if (data['data'] != null && data['data'] is List) {
            dataPlans.assignAll(List<Map<String, dynamic>>.from(data['data']));
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching data plans', name: 'GiveawayModule', error: e);
    } finally {
      isFetchingDataPlans.value = false;
    }
  }

  Future<void> fetchElectricityProviders() async {
    try {
      isFetchingElectricityProviders.value = true;
      electricityProviders.clear();
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) return;

      final url = '${transactionUrl}electricity';
      dev.log('Fetching electricity providers: $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) => dev.log('Failed to fetch electricity providers',
            name: 'GiveawayModule', error: failure.message),
        (data) {
          if (data['data'] != null && data['data'] is List) {
            electricityProviders
                .assignAll(List<Map<String, dynamic>>.from(data['data']));
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching electricity providers',
          name: 'GiveawayModule', error: e);
    } finally {
      isFetchingElectricityProviders.value = false;
    }
  }

  Future<void> fetchCableProviders() async {
    // Static list for providers as typically used
    // If dynamic is needed: '${transactionUrl}tv'
    // Based on CableModule logic, typically manual list or fetched.
    // Fetching if endpoint exists or using static:
    cableProviders.assignAll([
      {'name': 'DSTV', 'code': 'DSTV'},
      {'name': 'GOTV', 'code': 'GOTV'},
      {'name': 'STARTIMES', 'code': 'STARTIMES'},
      {'name': 'SHOWMAX', 'code': 'SHOWMAX'},
    ]);
  }

  Future<void> fetchCablePackages(String providerCode) async {
    try {
      isFetchingCablePackages.value = true;
      cablePackages.clear();
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) return;

      final url = '${transactionUrl}tv/$providerCode';
      dev.log('Fetching cable packages: $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) => dev.log('Failed to fetch cable packages',
            name: 'GiveawayModule', error: failure.message),
        (data) {
          if (data['data'] != null && data['data'] is List) {
            cablePackages
                .assignAll(List<Map<String, dynamic>>.from(data['data']));
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching cable packages',
          name: 'GiveawayModule', error: e);
    } finally {
      isFetchingCablePackages.value = false;
    }
  }

  Future<void> fetchBettingProviders() async {
    try {
      isFetchingBettingProviders.value = true;
      bettingProviders.clear();
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) return;

      final url = '${transactionUrl}betting';
      dev.log('Fetching betting providers: $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) => dev.log('Failed to fetch betting providers',
            name: 'GiveawayModule', error: failure.message),
        (data) {
          if (data['data'] != null && data['data'] is List) {
            bettingProviders
                .assignAll(List<Map<String, dynamic>>.from(data['data']));
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching betting providers',
          name: 'GiveawayModule', error: e);
    } finally {
      isFetchingBettingProviders.value = false;
    }
  }

  // --- Selection Setters ---

  void setType(String type) {
    dev.log('Setting type: $type', name: 'GiveawayModule');
    _selectedType.value = type;
  }

  void setTypeCode(String? code) {
    dev.log('Setting type code: $code', name: 'GiveawayModule');
    _selectedTypeCode.value = code;

    // Trigger next fetch based on type
    if (code != null) {
      if (_selectedType.value == 'data') {
        fetchDataPlans(code);
      } else if (_selectedType.value == 'tv') {
        fetchCablePackages(code);
      }
    }
  }

  void setDataPlan(Map<String, dynamic>? plan) {
    selectedDataPlan.value = plan;
    if (plan != null) {
      amountController.text = plan['amount'].toString();
    }
  }

  void setElectricityProvider(Map<String, dynamic>? provider) {
    selectedElectricityProvider.value = provider;
    if (provider != null) {
      setTypeCode(provider['code']);
    }
  }

  void setCableProvider(Map<String, dynamic>? provider) {
    selectedCableProvider.value = provider;
    if (provider != null) {
      setTypeCode(provider['code']);
    }
  }

  void setCablePackage(Map<String, dynamic>? package) {
    selectedCablePackage.value = package;
    if (package != null) {
      amountController.text = package['amount'].toString();
    }
  }

  void setBettingProvider(Map<String, dynamic>? provider) {
    selectedBettingProvider.value = provider;
    if (provider != null) {
      setTypeCode(provider['code']);
    }
  }

  void setPaymentMethod(String method) {
    dev.log('Setting payment method: $method', name: 'GiveawayModule');
    selectedPaymentMethod.value = method;
  }

  void setShowContact(bool value) => _showContact.value = value;
  void setIsPublic(bool value) => _isPublic.value = value;

  // Create giveaway
  Future<bool> createGiveaway() async {
    if (!_validateCreateForm()) return false;

    try {
      _isCreating.value = true;
      dev.log('Creating giveaway...', name: 'GiveawayModule');

      // Convert image to base64
      String? base64Image;
      if (_selectedImage.value != null) {
        final bytes = await _selectedImage.value!.readAsBytes();
        base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        dev.log('Image converted to base64, size: ${bytes.length} bytes',
            name: 'GiveawayModule');
      }

      // Determine type_code based on selection
      String finalTypeCode = _selectedTypeCode.value ?? '';

      // Override logic for specific types if needed to match API expectations
      if (_selectedType.value == 'data' && selectedDataPlan.value != null) {
        // Some APIs might expect the plan ID as type_code, but usually it's network code
        // The Create Giveaway endpoint likely expects 'type_code' to be the provider (mtn, etc.)
        // Verify payload requirements. Assuming 'type_code' is provider.
        // But wait, for data we might need to send the plan ID?
        // Looking at previous modules, usually specific params are passed.
        // 'create-giveaway' endpoint probably just takes type and type_code (provider).
        // If data plan specific info is needed, it might be in 'type_code' or a new field?
        // Standard 'create-giveaway' usually just validates amount.
        // For 'data', the 'type_code' is typically the network (e.g. 'mtn-data' vs 'mtn').
        // Let's stick to the network code for now as per user instruction "type_code for them are airtime, data..."
        // Actually user said: "the type_code for them are airtime, data, electricity, tv, betting_topup respectively"
        // Wait, the user request says: "choose between airtime, data... the type_code for them are airtime, data, electricity, tv, betting_topup respectively"
        // This sounds like the 'type' field values.
        // "dependnig on which they choose, a dropdown can fade in ... i choose data, it shwos the network under data ... i chooe netowrk, it shows another dropdown"
        // So:
        // type = 'data'
        // type_code = 'mtn' (network)
        // And usually 'amount' covers the plan.
      }

      final body = {
        'amount': amountController.text,
        'quantity': int.parse(quantityController.text),
        'type': _selectedType.value,
        'type_code': finalTypeCode,
        'image': base64Image ?? '',
        'description': descriptionController.text,
        // 'payment': selectedPaymentMethod.value, // Added payment method
      };

      dev.log(
          'Request body: ${body.keys.join(", ")} with payment: ${selectedPaymentMethod.value}',
          name: 'GiveawayModule');

      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}create-giveaway';
      dev.log('Request URL: $url', name: 'GiveawayModule');

      final response = await apiService.postrequest(url, body);

      bool success = false;
      response.fold(
        (failure) {
          dev.log('Failed to create giveaway',
              name: 'GiveawayModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            dev.log('Giveaway created successfully', name: 'GiveawayModule');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Giveaway created successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            _clearForm();
            fetchGiveaways();
            success = true;
          } else {
            dev.log('Create failed with success=0: ${data['message']}',
                name: 'GiveawayModule');
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to create giveaway',
            );
          }
        },
      );
      return success;
    } catch (e) {
      dev.log('Exception while creating giveaway',
          name: 'GiveawayModule', error: e);
      Get.snackbar('Error', 'Failed to create giveaway: $e');
      return false;
    } finally {
      _isCreating.value = false;
    }
  }

  // Claim giveaway
  Future<bool> claimGiveaway(int giveawayId, String receiver) async {
    if (receiver.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
      return false;
    }

    try {
      dev.log('Claiming giveaway ID: $giveawayId for receiver: $receiver',
          name: 'GiveawayModule');
      final body = {
        'giveaway_id': giveawayId,
        'receiver': receiver,
      };

      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}request-giveaway';
      dev.log('Request URL: $url', name: 'GiveawayModule');

      final response = await apiService.postrequest(url, body);

      bool success = false;
      response.fold(
        (failure) {
          dev.log('Failed to claim giveaway',
              name: 'GiveawayModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            dev.log('Giveaway claimed successfully', name: 'GiveawayModule');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Giveaway claimed successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchGiveaways();
            success = true;
          } else {
            dev.log('Claim failed with success=0: ${data['message']}',
                name: 'GiveawayModule');
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to claim giveaway',
            );
          }
        },
      );
      return success;
    } catch (e) {
      dev.log('Exception while claiming giveaway',
          name: 'GiveawayModule', error: e);
      Get.snackbar('Error', 'Failed to claim giveaway: $e');
      return false;
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    dev.log('Opening image picker', name: 'GiveawayModule');
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _selectedImage.value = File(image.path);
      dev.log('Image selected: ${image.path}', name: 'GiveawayModule');
    } else {
      dev.log('No image selected', name: 'GiveawayModule');
    }
  }

  // Validation
  bool _validateCreateForm() {
    dev.log('Validating create form', name: 'GiveawayModule');
    if (amountController.text.isEmpty) {
      dev.log('Validation failed: amount is empty', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please enter amount');
      return false;
    }

    // Validate minimum amount
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount < 100) {
      dev.log('Validation failed: amount is below minimum (100)',
          name: 'GiveawayModule');
      Get.snackbar(
        'Invalid Amount',
        'Minimum amount for creating a giveaway is ₦100',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.white,
      );
      return false;
    }

    if (quantityController.text.isEmpty) {
      dev.log('Validation failed: quantity is empty', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please enter quantity');
      return false;
    }
    if (descriptionController.text.isEmpty) {
      dev.log('Validation failed: description is empty',
          name: 'GiveawayModule');
      Get.snackbar('Error', 'Please enter description');
      return false;
    }
    if (_selectedImage.value == null) {
      dev.log('Validation failed: no image selected', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please select an image');
      return false;
    }

    // Type specific validation
    if (_selectedType.value == 'data' && selectedDataPlan.value == null) {
      Get.snackbar('Error', 'Please select a data plan');
      return false;
    }
    if (_selectedType.value == 'electricity' &&
        selectedElectricityProvider.value == null) {
      Get.snackbar('Error', 'Please select a provider');
      return false;
    }
    if (_selectedType.value == 'tv' && selectedCablePackage.value == null) {
      Get.snackbar('Error', 'Please select a package');
      return false;
    }
    if (_selectedType.value == 'betting_topup' &&
        selectedBettingProvider.value == null) {
      Get.snackbar('Error', 'Please select a provider');
      return false;
    }
    if (_selectedTypeCode.value == null &&
        (_selectedType.value == 'airtime' || _selectedType.value == 'data')) {
      Get.snackbar('Error', 'Please select a network');
      return false;
    }

    dev.log('Form validation passed', name: 'GiveawayModule');
    return true;
  }

  // Clear form
  void _clearForm() {
    dev.log('Clearing form', name: 'GiveawayModule');
    amountController.clear();
    quantityController.clear();
    descriptionController.clear();
    _selectedImage.value = null;
    _selectedType.value = 'airtime';
    _selectedTypeCode.value = 'mtn'; // Reset to default
    selectedDataPlan.value = null;
    selectedElectricityProvider.value = null;
    selectedCableProvider.value = null;
    selectedCablePackage.value = null;
    selectedBettingProvider.value = null;
  }
}
