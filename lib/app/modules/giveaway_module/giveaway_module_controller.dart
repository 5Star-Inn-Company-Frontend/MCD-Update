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
  
  // Helper getters for dropdown values (using codes instead of objects)
  String? get selectedDataPlanCode => selectedDataPlan.value?['coded'];
  String? get selectedElectricityProviderCode => selectedElectricityProvider.value?['code'];
  String? get selectedCableProviderCode => selectedCableProvider.value?['code'];
  String? get selectedCablePackageCode => selectedCablePackage.value?['coded'];
  String? get selectedBettingProviderCode => selectedBettingProvider.value?['code'];

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
    
    // Initialize static cable providers once (like cable module)
    // Use a Set to ensure uniqueness by code
    final uniqueProviders = <String, Map<String, dynamic>>{};
    final providerList = [
      {'name': 'DSTV', 'code': 'DSTV'},
      {'name': 'GOTV', 'code': 'GOTV'},
      {'name': 'STARTIMES', 'code': 'STARTIMES'},
      {'name': 'SHOWMAX', 'code': 'SHOWMAX'},
    ];
    
    for (var provider in providerList) {
      uniqueProviders[provider['code'] as String] = provider;
    }
    
    cableProviders.assignAll(uniqueProviders.values.toList());
    dev.log('Cable providers initialized: ${cableProviders.length}', name: 'GiveawayModule');
    dev.log('Cable provider codes: ${cableProviders.map((p) => p["code"]).join(", ")}', name: 'GiveawayModule');

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

      // Clear lists (but NOT cableProviders - it's static)
      dataPlans.clear();
      cablePackages.clear();

      // Auto-fetch providers if needed
      if (_selectedType.value == 'electricity') fetchElectricityProviders();
      // Cable providers are static, no need to fetch
      if (_selectedType.value == 'betting_topup') fetchBettingProviders();
    });
  }

  @override
  void onClose() {
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

      final utilityUrl = box.read('utility_service_url') ?? '';
      final url = '${utilityUrl}fetch-giveaways';
      final response = await apiService.getrequest(url);

      response.fold(
        (failure) {
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
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to fetch giveaways',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch giveaways: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Fetch single giveaway details
  Future<GiveawayDetailModel?> fetchGiveawayDetail(int id) async {
    try {
      dev.log('====== FETCH GIVEAWAY DETAIL - START ======',
          name: 'GiveawayModule');
      dev.log('REQUEST PARAMS: ID=$id', name: 'GiveawayModule');
      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}fetch-giveaway/$id';
      dev.log('REQUEST: GET $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      GiveawayDetailModel? detailModel;
      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== FETCH GIVEAWAY DETAIL - END (FAILED) ======',
              name: 'GiveawayModule');
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
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['success'] == 1) {
            detailModel = GiveawayDetailModel.fromJson(data['data']);
            dev.log('RESULT: Successfully fetched giveaway detail',
                name: 'GiveawayModule');
          } else {
            dev.log('RESULT: Fetch detail failed with success=0, message: ${data['message']}',
                name: 'GiveawayModule');
          }
          dev.log('====== FETCH GIVEAWAY DETAIL - END (SUCCESS) ======',
              name: 'GiveawayModule');
        },
      );
      return detailModel;
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== FETCH GIVEAWAY DETAIL - END (ERROR) ======',
          name: 'GiveawayModule');
      Get.snackbar('Error', 'Failed to fetch giveaway details: $e');
      return null;
    }
  }

  // --- New Methods for Dynamic Dropdowns ---

  Future<void> fetchDataPlans(String networkCode) async {
    try {
      isFetchingDataPlans.value = true;
      dataPlans.clear();
      dev.log('====== FETCH DATA PLANS - START ======', name: 'GiveawayModule');
      dev.log('REQUEST PARAMS: networkCode=$networkCode', name: 'GiveawayModule');
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('ERROR: transaction_service_url not found', name: 'GiveawayModule');
        return;
      }

      final url = '${transactionUrl}data/${networkCode.toUpperCase()}';
      dev.log('REQUEST: GET $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== FETCH DATA PLANS - END (FAILED) ======',
              name: 'GiveawayModule');
        },
        (data) {
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['data'] != null && data['data'] is List) {
            final plans = List<Map<String, dynamic>>.from(data['data']);
            
            // Remove duplicates based on 'coded' field
            final uniquePlans = <String, Map<String, dynamic>>{};
            for (var plan in plans) {
              final coded = plan['coded']?.toString() ?? '';
              if (coded.isNotEmpty && !uniquePlans.containsKey(coded)) {
                uniquePlans[coded] = plan;
              }
            }
            
            dataPlans.assignAll(uniquePlans.values.toList());
            dev.log('RESULT: Fetched ${dataPlans.length} unique data plans (${plans.length} total)',
                name: 'GiveawayModule');
          }
          dev.log('====== FETCH DATA PLANS - END (SUCCESS) ======',
              name: 'GiveawayModule');
        },
      );
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== FETCH DATA PLANS - END (ERROR) ======',
          name: 'GiveawayModule');
    } finally {
      isFetchingDataPlans.value = false;
    }
  }

  Future<void> fetchElectricityProviders() async {
    try {
      isFetchingElectricityProviders.value = true;
      electricityProviders.clear();
      dev.log('====== FETCH ELECTRICITY PROVIDERS - START ======',
          name: 'GiveawayModule');
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('ERROR: transaction_service_url not found', name: 'GiveawayModule');
        return;
      }

      final url = '${transactionUrl}electricity';
      dev.log('REQUEST: GET $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== FETCH ELECTRICITY PROVIDERS - END (FAILED) ======',
              name: 'GiveawayModule');
        },
        (data) {
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['data'] != null && data['data'] is List) {
            final providers = List<Map<String, dynamic>>.from(data['data']);
            
            // Remove duplicates based on 'code' field
            final uniqueProviders = <String, Map<String, dynamic>>{};
            for (var provider in providers) {
              final code = provider['code']?.toString() ?? '';
              if (code.isNotEmpty && !uniqueProviders.containsKey(code)) {
                uniqueProviders[code] = provider;
              }
            }
            
            electricityProviders.assignAll(uniqueProviders.values.toList());
            dev.log('RESULT: Fetched ${electricityProviders.length} unique providers (${providers.length} total)',
                name: 'GiveawayModule');
          }
          dev.log('====== FETCH ELECTRICITY PROVIDERS - END (SUCCESS) ======',
              name: 'GiveawayModule');
        },
      );
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== FETCH ELECTRICITY PROVIDERS - END (ERROR) ======',
          name: 'GiveawayModule');
    } finally {
      isFetchingElectricityProviders.value = false;
    }
  }

  // Cable providers are now static and initialized in onInit()
  // No need for fetchCableProviders() method

  Future<void> fetchCablePackages(String providerCode) async {
    try {
      isFetchingCablePackages.value = true;
      cablePackages.clear();
      dev.log('====== FETCH CABLE PACKAGES - START ======',
          name: 'GiveawayModule');
      dev.log('REQUEST PARAMS: providerCode=$providerCode',
          name: 'GiveawayModule');
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('ERROR: transaction_service_url not found', name: 'GiveawayModule');
        return;
      }

      final url = '${transactionUrl}tv/$providerCode';
      dev.log('REQUEST: GET $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== FETCH CABLE PACKAGES - END (FAILED) ======',
              name: 'GiveawayModule');
        },
        (data) {
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['data'] != null && data['data'] is List) {
            final packages = List<Map<String, dynamic>>.from(data['data']);
            
            // Remove duplicates based on 'code' field
            final uniquePackages = <String, Map<String, dynamic>>{};
            for (var package in packages) {
              final code = package['code']?.toString() ?? package['coded']?.toString() ?? '';
              if (code.isNotEmpty && !uniquePackages.containsKey(code)) {
                uniquePackages[code] = package;
              }
            }
            
            cablePackages.assignAll(uniquePackages.values.toList());
            dev.log('RESULT: Fetched ${cablePackages.length} unique packages (${packages.length} total)',
                name: 'GiveawayModule');
          }
          dev.log('====== FETCH CABLE PACKAGES - END (SUCCESS) ======',
              name: 'GiveawayModule');
        },
      );
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== FETCH CABLE PACKAGES - END (ERROR) ======',
          name: 'GiveawayModule');
    } finally {
      isFetchingCablePackages.value = false;
    }
  }

  Future<void> fetchBettingProviders() async {
    try {
      isFetchingBettingProviders.value = true;
      bettingProviders.clear();
      dev.log('====== FETCH BETTING PROVIDERS - START ======',
          name: 'GiveawayModule');
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('ERROR: transaction_service_url not found', name: 'GiveawayModule');
        return;
      }

      final url = '${transactionUrl}betting';
      dev.log('REQUEST: GET $url', name: 'GiveawayModule');

      final response = await apiService.getrequest(url);

      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== FETCH BETTING PROVIDERS - END (FAILED) ======',
              name: 'GiveawayModule');
        },
        (data) {
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['data'] != null && data['data'] is List) {
            final providers = List<Map<String, dynamic>>.from(data['data']);
            
            // Remove duplicates based on 'code' field
            final uniqueProviders = <String, Map<String, dynamic>>{};
            for (var provider in providers) {
              final code = provider['code']?.toString() ?? '';
              if (code.isNotEmpty && !uniqueProviders.containsKey(code)) {
                uniqueProviders[code] = provider;
              }
            }
            
            bettingProviders.assignAll(uniqueProviders.values.toList());
            dev.log('RESULT: Fetched ${bettingProviders.length} unique providers (${providers.length} total)',
                name: 'GiveawayModule');
          }
          dev.log('====== FETCH BETTING PROVIDERS - END (SUCCESS) ======',
              name: 'GiveawayModule');
        },
      );
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== FETCH BETTING PROVIDERS - END (ERROR) ======',
          name: 'GiveawayModule');
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

  void setDataPlan(String? planCode) {
    if (planCode != null) {
      final plan = dataPlans.firstWhere(
        (p) => p['coded'] == planCode,
        orElse: () => <String, dynamic>{},
      );
      if (plan.isNotEmpty) {
        selectedDataPlan.value = plan;
        // Data plans use 'price' field, not 'amount'
        final price = plan['price'] ?? plan['amount'] ?? '0';
        amountController.text = price.toString();
        dev.log('Data plan selected: ${plan['name']}, price: $price', name: 'GiveawayModule');
      }
    } else {
      selectedDataPlan.value = null;
    }
  }

  void setElectricityProvider(String? providerCode) {
    if (providerCode != null) {
      final provider = electricityProviders.firstWhere(
        (p) => p['code'] == providerCode,
        orElse: () => <String, dynamic>{},
      );
      if (provider.isNotEmpty) {
        selectedElectricityProvider.value = provider;
        dev.log('Electricity provider selected: ${provider['name']}, code: ${provider['code']}', 
            name: 'GiveawayModule');
      }
    } else {
      selectedElectricityProvider.value = null;
    }
  }

  void setCableProvider(String? providerCode) {
    if (providerCode != null) {
      final provider = cableProviders.firstWhere(
        (p) => p['code'] == providerCode,
        orElse: () => <String, dynamic>{},
      );
      if (provider.isNotEmpty) {
        selectedCableProvider.value = provider;
        dev.log('Cable provider selected: ${provider['name']}, code: ${provider['code']}', 
            name: 'GiveawayModule');
        setTypeCode(provider['code']);
      }
    } else {
      selectedCableProvider.value = null;
    }
  }

  void setCablePackage(String? packageCode) {
    if (packageCode != null) {
      final package = cablePackages.firstWhere(
        (p) => p['coded'] == packageCode,
        orElse: () => <String, dynamic>{},
      );
      if (package.isNotEmpty) {
        selectedCablePackage.value = package;
        // Cable packages use 'amount' field
        final amount = package['amount'] ?? package['price'] ?? '0';
        amountController.text = amount.toString();
        dev.log('Cable package selected: ${package['name']}, amount: $amount', name: 'GiveawayModule');
      }
    } else {
      selectedCablePackage.value = null;
    }
  }

  void setBettingProvider(String? providerCode) {
    if (providerCode != null) {
      final provider = bettingProviders.firstWhere(
        (p) => p['code'] == providerCode,
        orElse: () => <String, dynamic>{},
      );
      if (provider.isNotEmpty) {
        selectedBettingProvider.value = provider;
        dev.log('Betting provider selected: ${provider['name']}, code: ${provider['code']}', 
            name: 'GiveawayModule');
        setTypeCode(provider['code']);
      }
    } else {
      selectedBettingProvider.value = null;
    }
  }

  void setShowContact(bool value) => _showContact.value = value;
  void setIsPublic(bool value) => _isPublic.value = value;

  // Create giveaway
  Future<bool> createGiveaway() async {
    if (!_validateCreateForm()) return false;

    try {
      _isCreating.value = true;
      dev.log('====== CREATE GIVEAWAY - START ======', name: 'GiveawayModule');

      // Convert image to base64
      String? base64Image;
      if (_selectedImage.value != null) {
        final bytes = await _selectedImage.value!.readAsBytes();
        base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        dev.log('Image converted to base64, size: ${bytes.length} bytes',
            name: 'GiveawayModule');
      }

      // Determine type_code based on type and selection
      String finalTypeCode = '';
      
      switch (_selectedType.value) {
        case 'airtime':
          finalTypeCode = 'airtime';
          break;
        case 'data':
          // Use the 'coded' field from the selected data plan
          if (selectedDataPlan.value != null) {
            finalTypeCode = selectedDataPlan.value!['coded'] ?? '';
          }
          break;
        case 'electricity':
          // Use the 'code' field from the selected electricity provider
          if (selectedElectricityProvider.value != null) {
            finalTypeCode = selectedElectricityProvider.value!['code'] ?? '';
          }
          break;
        case 'tv':
          // Use the 'code' field from the selected cable package
          if (selectedCablePackage.value != null) {
            finalTypeCode = selectedCablePackage.value!['code'] ?? 
                           selectedCablePackage.value!['coded'] ?? '';
          }
          break;
        case 'betting_topup':
          finalTypeCode = 'betting';
          break;
        default:
          finalTypeCode = _selectedTypeCode.value ?? '';
      }

      dev.log('REQUEST PARAMS: Type=${_selectedType.value}, TypeCode=$finalTypeCode',
          name: 'GiveawayModule');

      final body = {
        'amount': amountController.text,
        'quantity': int.parse(quantityController.text),
        'type': _selectedType.value,
        'type_code': finalTypeCode,
        'image': base64Image ?? '',
        'description': descriptionController.text,
      };

      dev.log('REQUEST BODY: ${jsonEncode({...body, 'image': 'base64_image_data'})}',
          name: 'GiveawayModule');

      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}create-giveaway';
      dev.log('REQUEST: POST $url', name: 'GiveawayModule');

      final response = await apiService.postrequest(url, body);

      bool success = false;
      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== CREATE GIVEAWAY - END (FAILED) ======',
              name: 'GiveawayModule');
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['success'] == 1) {
            dev.log('RESULT: Giveaway created successfully', name: 'GiveawayModule');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Giveaway created successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            _clearForm();
            fetchGiveaways();
            success = true;
            dev.log('====== CREATE GIVEAWAY - END (SUCCESS) ======',
                name: 'GiveawayModule');
          } else {
            dev.log('RESULT: Create failed with success=0, message: ${data['message']}',
                name: 'GiveawayModule');
            dev.log('====== CREATE GIVEAWAY - END (FAILED) ======',
                name: 'GiveawayModule');
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to create giveaway',
            );
          }
        },
      );
      return success;
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== CREATE GIVEAWAY - END (ERROR) ======',
          name: 'GiveawayModule');
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
      dev.log('====== CLAIM GIVEAWAY - START ======', name: 'GiveawayModule');
      dev.log('REQUEST PARAMS: giveawayId=$giveawayId, receiver=$receiver',
          name: 'GiveawayModule');
      final body = {
        'giveaway_id': giveawayId,
        'receiver': receiver,
      };

      final utilityUrl = box.read('utility_service_url') ?? '';
      // final utilityUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${utilityUrl}request-giveaway';
      dev.log('REQUEST: POST $url', name: 'GiveawayModule');
      dev.log('REQUEST BODY: ${jsonEncode(body)}', name: 'GiveawayModule');

      final response = await apiService.postrequest(url, body);

      bool success = false;
      response.fold(
        (failure) {
          dev.log('RESPONSE: FAILURE - ${failure.message}',
              name: 'GiveawayModule');
          dev.log('====== CLAIM GIVEAWAY - END (FAILED) ======',
              name: 'GiveawayModule');
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('RESPONSE: SUCCESS - ${jsonEncode(data)}',
              name: 'GiveawayModule');
          if (data['success'] == 1) {
            dev.log('RESULT: Giveaway claimed successfully', name: 'GiveawayModule');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Giveaway claimed successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            fetchGiveaways();
            success = true;
            dev.log('====== CLAIM GIVEAWAY - END (SUCCESS) ======',
                name: 'GiveawayModule');
          } else {
            dev.log('RESULT: Claim failed with success=0, message: ${data['message']}',
                name: 'GiveawayModule');
            dev.log('====== CLAIM GIVEAWAY - END (FAILED) ======',
                name: 'GiveawayModule');
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to claim giveaway',
            );
          }
        },
      );
      return success;
    } catch (e, stackTrace) {
      dev.log('EXCEPTION: $e',
          name: 'GiveawayModule', error: e, stackTrace: stackTrace);
      dev.log('====== CLAIM GIVEAWAY - END (ERROR) ======',
          name: 'GiveawayModule');
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
      Get.snackbar('Error', 'Please select an image', backgroundColor: AppColors.errorBgColor, colorText: AppColors.white);
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
