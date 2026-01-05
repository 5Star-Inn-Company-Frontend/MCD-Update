import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class RecurringTransactionsModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final recurringTransactions = <RecurringTransaction>[].obs;
  final isLoadingList = false.obs;
  final isCreating = false.obs;
  final isModifying = false.obs;
  final isDeleting = false.obs;
  
  late final String? transactionRef;
  late final String? transactionName;
  late final double? transactionAmount;
  
  @override
  void onInit() {
    super.onInit();
    dev.log('RecurringTransactionsModuleController initialized', name: 'RecurringTransactions');
    
    // Get transaction details from arguments if creating new
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      transactionRef = arguments['ref'];
      transactionName = arguments['name'];
      transactionAmount = arguments['amount'];
      dev.log('Transaction ref for recurring: $transactionRef', name: 'RecurringTransactions');
    } else {
      transactionRef = null;
      transactionName = null;
      transactionAmount = null;
    }
    
    fetchRecurringTransactions();
  }
  
  Future<void> createRecurring(String frequency) async {
    if (transactionRef == null) {
      Get.snackbar(
        'Error',
        'No transaction reference provided',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }
    
    try {
      isCreating.value = true;
      dev.log('Creating recurring transaction - Ref: $transactionRef, Freq: $frequency', name: 'RecurringTransactions');
      
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        throw Exception('Transaction URL not found');
      }
      
      final body = {
        'ref': transactionRef,
        'freq': frequency,
      };
      
      final result = await apiService.postrequest('${transactionUrl}reoccurring/create', body);
      
      result.fold(
        (failure) {
          dev.log('Failed to create recurring transaction', name: 'RecurringTransactions', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Create recurring response: $data', name: 'RecurringTransactions');
          if (data['success'] == 1) {
            Get.snackbar(
              'Success',
              data['message'] ?? 'Recurring transaction created successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            
            // Refresh the list
            fetchRecurringTransactions();
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to create recurring transaction',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error creating recurring transaction', name: 'RecurringTransactions', error: e);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isCreating.value = false;
    }
  }
  
  Future<void> fetchRecurringTransactions() async {
    try {
      isLoadingList.value = true;
      dev.log('Fetching recurring transactions', name: 'RecurringTransactions');
      
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        throw Exception('Transaction URL not found');
      }
      
      final result = await apiService.getrequest('${transactionUrl}reoccurring/list');
      
      result.fold(
        (failure) {
          dev.log('Failed to fetch recurring transactions', name: 'RecurringTransactions', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Fetch recurring response: $data', name: 'RecurringTransactions');
          if (data['success'] == 1 && data['data'] != null) {
            final List<dynamic> dataList = data['data'] is List ? data['data'] : [];
            recurringTransactions.value = dataList
                .map((item) => RecurringTransaction.fromJson(item))
                .toList();
            dev.log('Loaded ${recurringTransactions.length} recurring transactions', name: 'RecurringTransactions');
          } else {
            recurringTransactions.clear();
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching recurring transactions', name: 'RecurringTransactions', error: e);
    } finally {
      isLoadingList.value = false;
    }
  }
  
  Future<void> modifyRecurring(int id, String newFrequency) async {
    try {
      isModifying.value = true;
      dev.log('Modifying recurring transaction - ID: $id, New Freq: $newFrequency', name: 'RecurringTransactions');
      
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        throw Exception('Transaction URL not found');
      }
      
      final body = {
        'freq': newFrequency,
      };
      
      final result = await apiService.postrequest('${transactionUrl}reoccurring/modify/$id', body);
      
      result.fold(
        (failure) {
          dev.log('Failed to modify recurring transaction', name: 'RecurringTransactions', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Modify recurring response: $data', name: 'RecurringTransactions');
          if (data['success'] == 1) {
            Get.snackbar(
              'Success',
              data['message'] ?? 'Recurring transaction updated successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            
            // Refresh the list
            fetchRecurringTransactions();
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to modify recurring transaction',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error modifying recurring transaction', name: 'RecurringTransactions', error: e);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isModifying.value = false;
    }
  }
  
  Future<void> deleteRecurring(int id) async {
    try {
      isDeleting.value = true;
      dev.log('Deleting recurring transaction - ID: $id', name: 'RecurringTransactions');
      
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        throw Exception('Transaction URL not found');
      }
      
      final result = await apiService.getrequest('${transactionUrl}reoccurring/delete/$id');
      
      result.fold(
        (failure) {
          dev.log('Failed to delete recurring transaction', name: 'RecurringTransactions', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Delete recurring response: $data', name: 'RecurringTransactions');
          if (data['success'] == 1) {
            Get.snackbar(
              'Success',
              data['message'] ?? 'Recurring transaction deleted successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            
            // Refresh the list
            fetchRecurringTransactions();
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to delete recurring transaction',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error deleting recurring transaction', name: 'RecurringTransactions', error: e);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isDeleting.value = false;
    }
  }
  
  void showFrequencyDialog({int? id, String? currentFrequency}) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                id == null ? 'Select Frequency' : 'Change Frequency',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, 
                  fontFamily: AppFonts.manRope,
                ),
              ),
              const SizedBox(height: 20),
              _frequencyOption('DAILY', 'Daily', 'Repeat every day', id, currentFrequency),
              const SizedBox(height: 12),
              _frequencyOption('WEEKLY', 'Weekly', 'Repeat every week', id, currentFrequency),
              const SizedBox(height: 12),
              _frequencyOption('MONTHLY', 'Monthly', 'Repeat every month', id, currentFrequency),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black, fontFamily: AppFonts.manRope)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _frequencyOption(String value, String title, String subtitle, int? id, String? currentFrequency) {
    final isSelected = currentFrequency == value;
    return InkWell(
      onTap: () {
        Get.back();
        if (id == null) {
          // Creating new
          createRecurring(value);
        } else {
          // Modifying existing
          modifyRecurring(id, value);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.primaryGrey2.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Icon(
              value == 'DAILY' 
                  ? Icons.today 
                  : value == 'WEEKLY' 
                      ? Icons.calendar_view_week 
                      : Icons.calendar_month,
              color: isSelected ? AppColors.primaryColor : AppColors.primaryGrey2,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryColor : Colors.black,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
  
  void showOptionsMenu(RecurringTransaction transaction) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primaryGrey2.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primaryColor),
              title: const Text('Modify Frequency', style: TextStyle(fontFamily: AppFonts.manRope)),
              onTap: () {
                Get.back();
                showFrequencyDialog(id: transaction.id, currentFrequency: transaction.frequency);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red, fontFamily: AppFonts.manRope)),
              onTap: () {
                Get.back();
                _confirmDelete(transaction);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  
  void _confirmDelete(RecurringTransaction transaction) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Recurring Transaction?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.manRope,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete this recurring transaction? This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontFamily: AppFonts.manRope, color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        deleteRecurring(transaction.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Delete', style: TextStyle(fontFamily: AppFonts.manRope, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecurringTransaction {
  final int id;
  final String ref;
  final String frequency;
  final String? name;
  final double? amount;
  final String? type;
  final String? createdAt;
  final String? nextSchedule;
  final String? network;
  final String? phone;
  final String? service;
  
  RecurringTransaction({
    required this.id,
    required this.ref,
    required this.frequency,
    this.name,
    this.amount,
    this.type,
    this.createdAt,
    this.nextSchedule,
    this.network,
    this.phone,
    this.service,
  });
  
  factory RecurringTransaction.fromJson(Map<String, dynamic> json) {
    // Extract serverlog data if available
    final serverlog = json['serverlog'] as Map<String, dynamic>?;
    final service = serverlog?['service'];
    final amount = serverlog?['amount'];
    final network = serverlog?['network'];
    final phone = serverlog?['phone'];
    final transid = serverlog?['transid'] ?? serverlog?['ident'];
    
    return RecurringTransaction(
      id: json['id'] ?? 0,
      ref: transid ?? json['ref'] ?? '',
      frequency: json['freq'] ?? json['frequency'] ?? 'DAILY',
      name: json['name'],
      amount: amount != null ? double.tryParse(amount.toString()) : null,
      type: service,
      createdAt: json['created_at'] ?? json['createdAt'],
      nextSchedule: json['next_schedule'] ?? json['nextSchedule'],
      network: network,
      phone: phone,
      service: service,
    );
  }
}
