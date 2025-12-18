import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/models/service_status_model.dart';
import 'package:mcd/core/network/dio_api_service.dart';

class ServiceStatusController extends GetxController {
  final DioApiService apiService = DioApiService();
  final storage = GetStorage();

  final Rx<ServiceStatusData?> serviceStatus = Rx<ServiceStatusData?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServiceStatus();
  }

  Future<void> fetchServiceStatus() async {
    isLoading.value = true;
    errorMessage.value = '';
    dev.log('Fetching service status', name: 'ServiceStatus');

    final transactionUrl = storage.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found', name: 'ServiceStatus', error: 'URL missing');
      errorMessage.value = 'Transaction URL not found';
      _loadCachedStatus();
      isLoading.value = false;
      return;
    }

    final result = await apiService.getrequest('${transactionUrl}services');

    result.fold(
      (failure) {
        dev.log('Failed to fetch service status', name: 'ServiceStatus', error: failure.message);
        errorMessage.value = failure.message;
        _loadCachedStatus();
      },
      (data) {
        if (data['success'] == 1) {
          dev.log('Service status fetched successfully', name: 'ServiceStatus');
          final model = ServiceStatusModel.fromJson(data);
          serviceStatus.value = model.data;
          
          // cache the service status
          if (model.data != null) {
            storage.write('cached_service_status', data);
            storage.write('service_status_timestamp', DateTime.now().toIso8601String());
          }
        } else {
          dev.log('Service status fetch failed', name: 'ServiceStatus', error: data['message']);
          errorMessage.value = data['message'] ?? 'Failed to fetch service status';
          _loadCachedStatus();
        }
      },
    );

    isLoading.value = false;
  }

  // load cached service status
  void _loadCachedStatus() {
    final cached = storage.read('cached_service_status');
    if (cached != null) {
      final model = ServiceStatusModel.fromJson(cached);
      serviceStatus.value = model.data;
    }
  }

  // check if a specific service is available
  bool isServiceAvailable(String serviceKey) {
    if (serviceStatus.value == null) {
      dev.log('Service status not loaded yet, allowing access to $serviceKey', name: 'ServiceStatus');
      return true; // allow access if status not yet fetched
    }
    final isAvailable = serviceStatus.value!.services.isServiceAvailable(serviceKey);
    dev.log('Service "$serviceKey" availability: ${isAvailable ? "AVAILABLE" : "UNAVAILABLE"}', name: 'ServiceStatus');
    return isAvailable;
  }

  // get service availability with user feedback
  Future<bool> checkServiceAvailability(String serviceKey, {String? serviceName}) async {
    dev.log('Checking service availability for "${serviceName ?? serviceKey}" (key: $serviceKey)', name: 'ServiceStatus');
    
    // if service status not loaded yet, fetch it
    if (serviceStatus.value == null) {
      dev.log('Service status not loaded, fetching now', name: 'ServiceStatus');
      await fetchServiceStatus();
    }

    final isAvailable = isServiceAvailable(serviceKey);

    if (!isAvailable) {
      dev.log('Service "${serviceName ?? serviceKey}" is UNAVAILABLE, showing dialog', name: 'ServiceStatus');
      _showServiceUnavailableDialog(serviceName ?? serviceKey);
    } else {
      dev.log('Service "${serviceName ?? serviceKey}" is AVAILABLE, allowing navigation', name: 'ServiceStatus');
    }

    return isAvailable;
  }

  // show service unavailable dialog
  void _showServiceUnavailableDialog(String serviceName) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Service Unavailable'),
          ],
        ),
        content: Text(
          '$serviceName service is currently unavailable. Please try again later.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              fetchServiceStatus(); // Retry fetching status
            },
            child: Text('Retry'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // refresh service status
  Future<void> refresh() async {
    await fetchServiceStatus();
  }

  // get specific service values
  String? getFreeMoneyAmount() {
    return serviceStatus.value?.services.freeMoneyAmount;
  }

  String? getSupportEmail() {
    return serviceStatus.value?.others?.supportEmail;
  }

  String? getAgentPhoneNumber() {
    return serviceStatus.value?.others?.mcdAgentPhoneno;
  }

  String? getUnityGameId() {
    return serviceStatus.value?.adverts?.unityGameid;
  }

  bool isUnityTestMode() {
    return serviceStatus.value?.adverts?.unityTestmode.toLowerCase() == 'true';
  }

  bool isLeaderboardActive() {
    return serviceStatus.value?.others?.leaderboard == '1';
  }
}
