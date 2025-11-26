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
  final selectedPaymentMethod = 'wallet'.obs; // wallet, paystack, general_market, mega_bonus
  
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
  final _selectedType = 'airtime'.obs;
  final _selectedTypeCode = 'mtn'.obs;
  final _selectedImage = Rx<File?>(null);
  final _showContact = true.obs;
  final _isPublic = true.obs;
  
  String get selectedType => _selectedType.value;
  String get selectedTypeCode => _selectedTypeCode.value;
  File? get selectedImage => _selectedImage.value;
  bool get showContact => _showContact.value;
  bool get isPublic => _isPublic.value;
  
  @override
  void onInit() {
    super.onInit();
    dev.log('GiveawayModule initialized', name: 'GiveawayModule');
    fetchGiveaways();
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
      
      // final transactionUrl = box.read('utility_service_url') ?? '';
      final transactionUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${transactionUrl}fetch-giveaways';
      dev.log('Request URL: $url', name: 'GiveawayModule');
      
      final response = await apiService.getrequest(url);
      
      response.fold(
        (failure) {
          dev.log('Failed to fetch giveaways', name: 'GiveawayModule', error: failure.message);
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
            _giveaways.value = giveawaysData.map((e) => GiveawayModel.fromJson(e)).toList();
            _myGiveawayCount.value = data['mygiveaway'] ?? 0;
            dev.log('Fetched ${_giveaways.length} giveaways, myCount: ${_myGiveawayCount.value}', name: 'GiveawayModule');
          } else {
            dev.log('Fetch failed with success=0', name: 'GiveawayModule');
          }
        },
      );
    } catch (e) {
      dev.log('Exception while fetching giveaways', name: 'GiveawayModule', error: e);
      Get.snackbar('Error', 'Failed to fetch giveaways: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Fetch single giveaway details
  Future<GiveawayDetailModel?> fetchGiveawayDetail(int id) async {
    try {
      dev.log('Fetching giveaway detail for ID: $id', name: 'GiveawayModule');
      // final transactionUrl = box.read('utility_service_url') ?? '';
      final transactionUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${transactionUrl}fetch-giveaway/$id';
      dev.log('Request URL: $url', name: 'GiveawayModule');
      
      final response = await apiService.getrequest(url);
      
      GiveawayDetailModel? detailModel;
      response.fold(
        (failure) {
          dev.log('Failed to fetch giveaway detail', name: 'GiveawayModule', error: failure.message);
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
            dev.log('Successfully fetched giveaway detail', name: 'GiveawayModule');
          } else {
            dev.log('Fetch detail failed with success=0', name: 'GiveawayModule');
          }
        },
      );
      return detailModel;
    } catch (e) {
      dev.log('Exception while fetching giveaway detail', name: 'GiveawayModule', error: e);
      Get.snackbar('Error', 'Failed to fetch giveaway details: $e');
      return null;
    }
  }
  
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
        base64Image = base64Encode(bytes);
        dev.log('Image converted to base64, size: ${bytes.length} bytes', name: 'GiveawayModule');
      }
      
      final body = {
        'amount': amountController.text,
        'quantity': int.parse(quantityController.text),
        'type': _selectedType.value,
        'type_code': _selectedTypeCode.value,
        'image': base64Image ?? '',
        'description': descriptionController.text,
        'payment': selectedPaymentMethod.value, // Added payment method
      };
      dev.log('Request body: ${body.keys.join(", ")} with payment: ${selectedPaymentMethod.value}', name: 'GiveawayModule');
      
      // final transactionUrl = box.read('utility_service_url') ?? '';
      final transactionUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${transactionUrl}create-giveaway';
      dev.log('Request URL: $url', name: 'GiveawayModule');
      
      final response = await apiService.postrequest(url, body);
      
      bool success = false;
      response.fold(
        (failure) {
          dev.log('Failed to create giveaway', name: 'GiveawayModule', error: failure.message);
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
            dev.log('Create failed with success=0: ${data['message']}', name: 'GiveawayModule');
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to create giveaway',
            );
          }
        },
      );
      return success;
    } catch (e) {
      dev.log('Exception while creating giveaway', name: 'GiveawayModule', error: e);
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
      dev.log('Claiming giveaway ID: $giveawayId for receiver: $receiver', name: 'GiveawayModule');
      final body = {
        'giveaway_id': giveawayId,
        'receiver': receiver,
      };
      
      // final transactionUrl = box.read('utility_service_url') ?? '';
      final transactionUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/';
      final url = '${transactionUrl}request-giveaway';
      dev.log('Request URL: $url', name: 'GiveawayModule');
      
      final response = await apiService.postrequest(url, body);
      
      bool success = false;
      response.fold(
        (failure) {
          dev.log('Failed to claim giveaway', name: 'GiveawayModule', error: failure.message);
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
            dev.log('Claim failed with success=0: ${data['message']}', name: 'GiveawayModule');
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to claim giveaway',
            );
          }
        },
      );
      return success;
    } catch (e) {
      dev.log('Exception while claiming giveaway', name: 'GiveawayModule', error: e);
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
  
  // Form setters
  void setType(String type) {
    dev.log('Setting type: $type', name: 'GiveawayModule');
    _selectedType.value = type;
  }
  
  void setTypeCode(String code) {
    dev.log('Setting type code: $code', name: 'GiveawayModule');
    _selectedTypeCode.value = code;
  }
  
  void setPaymentMethod(String method) {
    dev.log('Setting payment method: $method', name: 'GiveawayModule');
    selectedPaymentMethod.value = method;
  }
  
  void setShowContact(bool value) => _showContact.value = value;
  void setIsPublic(bool value) => _isPublic.value = value;
  
  // Validation
  bool _validateCreateForm() {
    dev.log('Validating create form', name: 'GiveawayModule');
    if (amountController.text.isEmpty) {
      dev.log('Validation failed: amount is empty', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please enter amount');
      return false;
    }
    if (quantityController.text.isEmpty) {
      dev.log('Validation failed: quantity is empty', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please enter quantity');
      return false;
    }
    if (descriptionController.text.isEmpty) {
      dev.log('Validation failed: description is empty', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please enter description');
      return false;
    }
    if (_selectedImage.value == null) {
      dev.log('Validation failed: no image selected', name: 'GiveawayModule');
      Get.snackbar('Error', 'Please select an image');
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
    _selectedTypeCode.value = 'mtn';
  }
}