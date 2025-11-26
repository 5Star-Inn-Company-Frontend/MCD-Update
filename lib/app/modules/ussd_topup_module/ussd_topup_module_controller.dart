import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class UssdTopupModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final formKey = GlobalKey<FormState>();
  final accountNumberController = TextEditingController();
  final amountController = TextEditingController();
  final bankSearchController = TextEditingController();
  
  final selectedBank = 'Choose bank'.obs;
  final selectedBankCode = ''.obs;
  final selectedBankUssd = ''.obs;
  final accountName = ''.obs;
  final generatedCode = ''.obs;
  final banks = <Map<String, String>>[].obs;
  final isLoadingBanks = false.obs;
  final isValidatingAccount = false.obs;
  final isGeneratingCode = false.obs;
  final showCopyInfo = false.obs;
  final _bankSearchQuery = ''.obs;
  
  String get bankSearchQuery => _bankSearchQuery.value;
  set bankSearchQuery(String value) => _bankSearchQuery.value = value;
  
  List<Map<String, String>> get filteredBanks {
    if (bankSearchQuery.isEmpty) {
      return banks;
    }
    return banks.where((bank) => 
      bank['name']!.toLowerCase().contains(bankSearchQuery.toLowerCase())
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('UssdTopupModuleController initialized', name: 'UssdTopup');
    fetchBanks();
  }

  @override
  void onClose() {
    accountNumberController.dispose();
    amountController.dispose();
    bankSearchController.dispose();
    super.onClose();
  }
  
  Future<void> fetchBanks() async {
    try {
      isLoadingBanks.value = true;
      dev.log('Fetching banks list', name: 'UssdTopup');
      
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'UssdTopup', error: 'URL missing');
        Get.snackbar(
          'Error',
          'Service configuration error. Please login again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      
      final result = await apiService.getrequest('${transactionUrl}banklist');
      
      result.fold(
        (failure) {
          dev.log('Failed to fetch banks', name: 'UssdTopup', error: failure.message);
          Get.snackbar(
            'Error',
            'Failed to load banks: ${failure.message}',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1 && data['data'] != null) {
            banks.clear();
            for (var bank in data['data']) {
              banks.add({
                'name': bank['name'] ?? '',
                'code': bank['code'] ?? '',
                'ussd': bank['ussd'] ?? '',
              });
            }
            dev.log('Banks loaded: ${banks.length} banks', name: 'UssdTopup');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching banks', name: 'UssdTopup', error: e);
      Get.snackbar(
        'Error',
        'An error occurred while loading banks',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoadingBanks.value = false;
    }
  }
  
  void selectBank(String bankName, String bankCode, String ussd) {
    selectedBank.value = bankName;
    selectedBankCode.value = bankCode;
    selectedBankUssd.value = ussd;
    dev.log('Bank selected: $bankName - $bankCode - $ussd', name: 'UssdTopup');
    Get.back();
    
    // Validate account if number is already entered
    if (accountNumberController.text.length == 10) {
      validateAccountNumber();
    }
  }
  
  Future<void> validateAccountNumber() async {
    if (accountNumberController.text.length != 10) {
      return;
    }
    
    if (selectedBankCode.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a bank first',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    try {
      isValidatingAccount.value = true;
      accountName.value = '';
      dev.log('Validating account: ${accountNumberController.text} at bank: $selectedBankCode', name: 'UssdTopup');
      
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found', name: 'UssdTopup', error: 'URL missing');
        return;
      }
      
      final body = {
        'accountnumber': accountNumberController.text,
        'code': selectedBankCode.value,
      };
      
      final result = await apiService.postrequest('${transactionUrl}verifyBank', body);
      
      result.fold(
        (failure) {
          dev.log('Account validation failed', name: 'UssdTopup', error: failure.message);
          accountName.value = '';
        },
        (data) {
          if (data['success'] == 1) {
            accountName.value = data['data'] ?? '';
            dev.log('Account validated: ${accountName.value}', name: 'UssdTopup');
          } else {
            accountName.value = '';
          }
        },
      );
    } catch (e) {
      dev.log('Error validating account', name: 'UssdTopup', error: e);
    } finally {
      isValidatingAccount.value = false;
    }
  }
  
  Future<void> generateCode() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    if (selectedBankCode.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a bank',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    if (accountName.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please wait for account validation',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    try {
      isGeneratingCode.value = true;
      dev.log('Generating USSD code', name: 'UssdTopup');
      
      // Simulate code generation - replace with actual API call if needed
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate code format: *bankUssd*amount*accountNumber#
      final code = '*${selectedBankUssd.value}*${amountController.text}*${accountNumberController.text}#';
      generatedCode.value = code;
      
      dev.log('USSD code generated: $code', name: 'UssdTopup');
      
    } catch (e) {
      dev.log('Error generating code', name: 'UssdTopup', error: e);
      Get.snackbar(
        'Error',
        'Failed to generate code',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isGeneratingCode.value = false;
    }
  }
  
  Future<void> copyCode() async {
    if (generatedCode.value.isEmpty) return;
    
    await Clipboard.setData(ClipboardData(text: generatedCode.value));
    dev.log('USSD code copied to clipboard: ${generatedCode.value}', name: 'UssdTopup');
    
    // Show info tile
    showCopyInfo.value = true;
    
    // Hide info tile after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      showCopyInfo.value = false;
    });
    
    Get.snackbar(
      "Copied",
      "USSD code copied to clipboard",
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      colorText: AppColors.primaryColor,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Icons.check_circle, color: AppColors.primaryColor),
    );
  }
  
  void resetForm() {
    accountNumberController.clear();
    amountController.clear();
    selectedBank.value = 'Choose bank';
    selectedBankCode.value = '';
    selectedBankUssd.value = '';
    accountName.value = '';
    generatedCode.value = '';
    showCopyInfo.value = false;
  }
}
