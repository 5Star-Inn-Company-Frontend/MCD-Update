import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/styles/app_colors.dart';

class SpinWinItem {
  final int id;
  final String name;
  final String type;
  final String network;
  final int amount;
  final bool requiresInput;
  
  SpinWinItem({
    required this.id,
    required this.name,
    required this.type,
    required this.network,
    required this.amount,
    required this.requiresInput,
  });
  
  factory SpinWinItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] ?? 'empty';
    // Airtime and data require phone number input, wallet and empty don't
    final requiresInput = type == 'airtime' || type == 'data';
    
    // Parse amount - handle both int and string
    int amount = 0;
    if (json['amount'] != null) {
      if (json['amount'] is int) {
        amount = json['amount'];
      } else if (json['amount'] is String) {
        amount = int.tryParse(json['amount']) ?? 0;
      }
    }
    
    return SpinWinItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: type,
      network: json['network'] ?? '',
      amount: amount,
      requiresInput: requiresInput,
    );
  }
}

class SpinWinModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  // Observables
  final _spinItems = <SpinWinItem>[].obs;
  final _chancesRemaining = 5.obs;
  final _timesPlayed = 0.obs;
  final _isLoading = false.obs;
  final _isSpinning = false.obs;
  final selected = 0.obs;
  
  // Phone number controller for dialog
  final phoneNumberController = TextEditingController();
  
  // Stream controller for fortune wheel
  final StreamController<int> _selectedController = StreamController<int>.broadcast();
  Stream<int> get selectedStream => _selectedController.stream;
  
  // Getters
  List<SpinWinItem> get spinItems => _spinItems;
  int get chancesRemaining => _chancesRemaining.value;
  int get timesPlayed => _timesPlayed.value;
  bool get isLoading => _isLoading.value;
  bool get isSpinning => _isSpinning.value;
  
  @override
  void onInit() {
    super.onInit();
    dev.log('SpinWinModule initialized', name: 'SpinWinModule');
    _loadLocalChances();
    fetchSpinData();
  }
  
  @override
  void onClose() {
    phoneNumberController.dispose();
    _selectedController.close();
    super.onClose();
  }
  
  // Load chances from local storage
  void _loadLocalChances() {
    final savedChances = box.read('spin_chances_remaining');
    final lastResetTime = box.read('spin_last_reset_time');
    
    if (savedChances != null && lastResetTime != null) {
      final lastReset = DateTime.parse(lastResetTime);
      final now = DateTime.now();
      final hoursSinceReset = now.difference(lastReset).inHours;
      
      // Reset if 5 hours have passed
      if (hoursSinceReset >= 5) {
        _chancesRemaining.value = 5;
        box.write('spin_chances_remaining', 5);
        box.write('spin_last_reset_time', now.toIso8601String());
        dev.log('Chances reset after 5 hours', name: 'SpinWinModule');
      } else {
        _chancesRemaining.value = savedChances;
        dev.log('Loaded saved chances: $savedChances', name: 'SpinWinModule');
      }
    } else {
      // First time - initialize
      _chancesRemaining.value = 5;
      box.write('spin_chances_remaining', 5);
      box.write('spin_last_reset_time', DateTime.now().toIso8601String());
    }
  }
  
  // Save chances to local storage
  void _saveChances() {
    box.write('spin_chances_remaining', _chancesRemaining.value);
    dev.log('Saved chances: ${_chancesRemaining.value}', name: 'SpinWinModule');
  }
  
  // Fetch spin data from API
  Future<void> fetchSpinData() async {
    try {
      _isLoading.value = true;
      dev.log('Fetching spin data...', name: 'SpinWinModule');
      
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
      
      final url = '${utilityUrl}spinwin-fetch';
      dev.log('Fetching from: $url', name: 'SpinWinModule');
      
      final result = await apiService.getrequest(url);
      
      result.fold(
        (failure) {
          dev.log('Failed to fetch spin data', name: 'SpinWinModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (response) {
          dev.log('Spin data response: $response', name: 'SpinWinModule');
          
          if (response['success'] == 1 && response['data'] != null) {
            final data = response['data'];
            
            // Parse items - data is directly an array
            if (data is List) {
              _spinItems.value = data
                  .map((item) => SpinWinItem.fromJson(item as Map<String, dynamic>))
                  .toList();
              
              dev.log('Loaded ${_spinItems.length} items', name: 'SpinWinModule');
            }
          }
        },
      );
    } catch (e) {
      dev.log('Exception while fetching spin data', name: 'SpinWinModule', error: e);
      Get.snackbar(
        'Error',
        'Failed to fetch spin data: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Perform spin action
  Future<void> performSpin() async {
    if (_chancesRemaining.value <= 0) {
      Get.snackbar(
        'No Chances',
        'You have no spin chances remaining. Please wait 5 hours.',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    if (_spinItems.isEmpty) {
      Get.snackbar(
        'Error',
        'No spin items available',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    try {
      _isSpinning.value = true;
      dev.log('Performing spin...', name: 'SpinWinModule');
      
      // Generate random index for spin result
      final randomIndex = DateTime.now().millisecondsSinceEpoch % _spinItems.length;
      selected.value = randomIndex;
      
      // Trigger the wheel to spin
      _selectedController.add(randomIndex);
      
      // Wait for animation to complete
      await Future.delayed(const Duration(seconds: 4));
      
      final wonItem = _spinItems[randomIndex];
      dev.log('Spin landed on: ${wonItem.name}', name: 'SpinWinModule');
      
      // Increment times played
      _timesPlayed.value++;
      _chancesRemaining.value--;
      _saveChances(); // Save after decrementing
      
      // Check if item requires user input
      if (wonItem.requiresInput) {
        _showPhoneNumberDialog(wonItem);
      } else {
        // Submit without phone number
        await _submitSpinResult(wonItem, null);
      }
      
    } catch (e) {
      dev.log('Exception while performing spin', name: 'SpinWinModule', error: e);
      Get.snackbar(
        'Error',
        'Failed to perform spin: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      _isSpinning.value = false;
    }
  }
  
  // Show dialog for phone number input
  void _showPhoneNumberDialog(SpinWinItem item) {
    phoneNumberController.clear();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                color: AppColors.primaryColor,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Congratulations!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You won: ${item.name}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '08012345678',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        phoneNumberController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primaryGrey),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (phoneNumberController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter phone number',
                            backgroundColor: AppColors.errorBgColor,
                            colorText: AppColors.textSnackbarColor,
                          );
                          return;
                        }
                        Get.back();
                        _submitSpinResult(item, phoneNumberController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  // Submit spin result to API
  Future<void> _submitSpinResult(SpinWinItem item, String? phoneNumber) async {
    try {
      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null || utilityUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'Service URL not found',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }
      
      final url = '${utilityUrl}spinwin-continue';
      dev.log('Submitting spin result to: $url', name: 'SpinWinModule');
      
      final body = {
        'id': item.id,
        'ids': item.id.toString(),
        'number': phoneNumber ?? '',
        'timesPlayed': _timesPlayed.value.toString(),
      };
      
      dev.log('Request body: $body', name: 'SpinWinModule');
      
      final result = await apiService.postrequest(url, body);
      
      result.fold(
        (failure) {
          dev.log('Failed to submit spin result', name: 'SpinWinModule', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (response) {
          dev.log('Spin result submitted: $response', name: 'SpinWinModule');
          
          Get.snackbar(
            'Success!',
            response['message'] ?? 'Your reward has been processed successfully',
            backgroundColor: AppColors.successBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 3),
          );
          
          // Refresh spin data
          fetchSpinData();
        },
      );
    } catch (e) {
      dev.log('Exception while submitting spin result', name: 'SpinWinModule', error: e);
      Get.snackbar(
        'Error',
        'Failed to submit: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    }
  }
}
