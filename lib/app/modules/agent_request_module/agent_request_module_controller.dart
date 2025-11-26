import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;
import 'package:mcd/app/styles/app_colors.dart';

class AgentRequestModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final step1 = false.obs;
  final step2 = false.obs;
  final step3 = false.obs;

  // Personal Info Form
  final personalInfoFormKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final isPersonalInfoFormValid = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgentStatus();
    
    // Listen to form field changes for validation
    firstNameController.addListener(_validatePersonalInfoForm);
    businessNameController.addListener(_validatePersonalInfoForm);
    dobController.addListener(_validatePersonalInfoForm);
    phoneNumberController.addListener(_validatePersonalInfoForm);
    addressController.addListener(_validatePersonalInfoForm);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    businessNameController.dispose();
    dobController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void _validatePersonalInfoForm() {
    isPersonalInfoFormValid.value = 
      firstNameController.text.isNotEmpty &&
      businessNameController.text.isNotEmpty &&
      dobController.text.isNotEmpty &&
      phoneNumberController.text.isNotEmpty &&
      addressController.text.isNotEmpty;
  }

  Future<void> fetchAgentStatus() async {
    try {
      isLoading.value = true;

      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null || utilityUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'Service URL not found. Please log in again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      // final fullUrl = '${utilityUrl}agentstatus';
      final fullUrl = 'https://utility.mcd.5starcompany.com.ng/api/v1/agentstatus';
      dev.log('Request URL: $fullUrl', name: 'AgentRequest');
      final result = await apiService.getrequest(fullUrl);

      result.fold(
        (failure) {
          dev.log('Failed to fetch agent status', name: 'AgentRequest', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (response) {
          dev.log('Agent status fetched successfully', name: 'AgentRequest');
          if (response['success'] == 1 && response['data'] != null) {
            final data = response['data'];
            step1.value = data['step1'] ?? false;
            step2.value = data['step2'] ?? false;
            step3.value = data['step3'] ?? false;
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching agent status', name: 'AgentRequest', error: e);
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showBenefitsBottomSheet() {
    // This will be called when "See Benefits" button is tapped
  }

  void showTasksBottomSheet() {
    // This will be called when "My Tasks" button is tapped
  }

  Future<void> submitAgentRequest() async {
    if (!personalInfoFormKey.currentState!.validate()) {
      return;
    }

    try {
      isSubmitting.value = true;

      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null || utilityUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'Service URL not found. Please log in again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      // Parse address into components
      final addressParts = addressController.text.split('/').map((e) => e.trim()).toList();
      final street = addressParts.length > 1 ? addressParts[1] : addressController.text;
      final state = addressParts.length > 2 ? addressParts[2] : '';
      final country = addressParts.length > 3 ? addressParts[3] : '';

      final fullUrl = '${utilityUrl}agent';
      dev.log('Request URL: $fullUrl', name: 'AgentRequest');
      
      final payload = {
        'full_name': firstNameController.text.trim(),
        'company_name': businessNameController.text.trim(),
        'bvn': '', // BVN will be added from KYC verification
        'dob': dobController.text.trim(),
        'street': street,
        'state': state,
        'country': country,
      };

      dev.log('Payload: $payload', name: 'AgentRequest');

      final result = await apiService.postrequest(fullUrl, payload);

      result.fold(
        (failure) {
          dev.log('Failed to submit agent request', name: 'AgentRequest', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (response) {
          dev.log('Agent request submitted successfully', name: 'AgentRequest');
          Get.snackbar(
            'Success',
            'Your agent request has been submitted successfully',
            backgroundColor: AppColors.primaryColor,
            colorText: AppColors.white,
          );
          
          // Clear form and navigate back
          firstNameController.clear();
          businessNameController.clear();
          dobController.clear();
          phoneNumberController.clear();
          addressController.clear();
          
          Get.back();
          
          // Refresh agent status
          fetchAgentStatus();
        },
      );
    } catch (e) {
      dev.log('Error submitting agent request', name: 'AgentRequest', error: e);
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}