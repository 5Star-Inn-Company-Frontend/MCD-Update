import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/app/styles/app_colors.dart';

class SpinWinModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  // Observables
  final _chancesRemaining = 5.obs;
  final _isLoading = false.obs;
  final _isSpinning = false.obs;
  
  // Getters
  int get chancesRemaining => _chancesRemaining.value;
  bool get isLoading => _isLoading.value;
  bool get isSpinning => _isSpinning.value;
  
  @override
  void onInit() {
    super.onInit();
    dev.log('SpinWinModule initialized', name: 'SpinWinModule');
    fetchSpinData();
  }
  
  // Fetch spin data (chances remaining, etc.)
  Future<void> fetchSpinData() async {
    try {
      _isLoading.value = true;
      dev.log('Fetching spin data...', name: 'SpinWinModule');
      
      // TODO: Replace with actual API endpoint
      // final utilityUrl = box.read('utility_service_url') ?? '';
      // final url = '${utilityUrl}fetch-spin-chances';
      // final response = await apiService.getrequest(url);
      
      // For now, just simulate
      await Future.delayed(const Duration(milliseconds: 500));
      _chancesRemaining.value = 5;
      
      dev.log('Spin data fetched: ${_chancesRemaining.value} chances', name: 'SpinWinModule');
    } catch (e) {
      dev.log('Exception while fetching spin data', name: 'SpinWinModule', error: e);
      Get.snackbar('Error', 'Failed to fetch spin data: $e');
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
    
    try {
      _isSpinning.value = true;
      dev.log('Performing spin...', name: 'SpinWinModule');
      
      // TODO: Replace with actual API endpoint
      // final utilityUrl = box.read('utility_service_url') ?? '';
      // final url = '${utilityUrl}perform-spin';
      // final response = await apiService.postrequest(url, {});
      
      // Simulate spin (2-3 seconds)
      await Future.delayed(const Duration(seconds: 3));
      
      // Simulate response
      _chancesRemaining.value = _chancesRemaining.value - 1;
      
      Get.snackbar(
        'Congratulations!',
        'You won ₦100 airtime!',
        backgroundColor: AppColors.primaryColor,
        colorText: AppColors.white,
      );
      
      dev.log('Spin completed. Remaining chances: ${_chancesRemaining.value}', name: 'SpinWinModule');
    } catch (e) {
      dev.log('Exception while performing spin', name: 'SpinWinModule', error: e);
      Get.snackbar('Error', 'Failed to perform spin: $e');
    } finally {
      _isSpinning.value = false;
    }
  }
}
