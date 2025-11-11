import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/history_screen_module/models/transaction_history_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class TransactionUIModel {
  final String name;
  final String image;
  final double amount;
  final String time;

  TransactionUIModel({
    required this.name,
    required this.image,
    required this.amount,
    required this.time,
  });
}

class HistoryScreenController extends GetxController {
  var apiService = DioApiService();
  final box = GetStorage();

  final _filterBy = 'All'.obs;
  String get filterBy => _filterBy.value;
  set filterBy(String value) {
    _filterBy.value = value;
    fetchTransactions(); // Refetch when filter changes
  }

  final _statusFilter = 'All Status'.obs;
  String get statusFilter => _statusFilter.value;
  set statusFilter(String value) {
    _statusFilter.value = value;
    fetchTransactions(); // Refetch when status filter changes
  }

  final _selectedValue = 'January'.obs;
  String get selectedValue => _selectedValue.value;
  set selectedValue(String value) => _selectedValue.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<TransactionHistoryModel> _transactionHistory = Rxn<TransactionHistoryModel>();
  TransactionHistoryModel? get transactionHistory => _transactionHistory.value;

  final _totalIn = 0.0.obs;
  double get totalIn => _totalIn.value;

  final _totalOut = 0.0.obs;
  double get totalOut => _totalOut.value;

  final List<String> months = [
    'January',
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  // Get filtered transactions
  List<Transaction> get filteredTransactions {
    if (transactionHistory == null) return [];
    return transactionHistory!.transactions;
  }

  @override
  void onInit() {
    selectedValue = months.first;
    dev.log('Initializing History Screen', name: 'HistoryScreen');
    fetchTransactions();
    fetchTransactionSummary();
    super.onInit();
  }

  // Fetch transaction summary (inflow/outflow)
  Future<void> fetchTransactionSummary() async {
    try {
      dev.log('Fetching transaction summary...', name: 'HistoryScreen');
      
      final utilityUrl = box.read('transaction_service_url') ?? '';
      final url = '${utilityUrl}transactions-summary';
      dev.log('Summary URL: $url', name: 'HistoryScreen');

      final response = await apiService.getJsonRequest(url);

      response.fold(
        (failure) {
          dev.log('Failed to fetch summary', name: 'HistoryScreen', error: failure.message);
        },
        (data) {
          dev.log('Summary response received', name: 'HistoryScreen');
          if (data['success'] == 1) {
            _totalIn.value = double.tryParse(data['data']['inflow'].toString()) ?? 0.0;
            _totalOut.value = double.tryParse(data['data']['outflow'].toString()) ?? 0.0;
            dev.log('Summary - In: $_totalIn, Out: $_totalOut', name: 'HistoryScreen');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching summary', name: 'HistoryScreen', error: e);
    }
  }

  // Fetch transactions from API with filters
  Future<void> fetchTransactions() async {
    try {
      _isLoading.value = true;
      dev.log('Fetching transactions...', name: 'HistoryScreen');
      
      final utilityUrl = box.read('transaction_service_url') ?? '';
      
      // Build query parameters based on filters
      String queryParams = '';
      
      // Add type filter (convert UI filter to API parameter)
      if (filterBy == 'Money in') {
        // For money in, we might need to filter by specific codes or leave empty
        // The API will return all, and we can filter client-side if needed
      } else if (filterBy == 'Money out') {
        // Add type parameter for specific service types like airtime, data, etc.
        queryParams += 'type=';
      } else {
        // All transactions
        queryParams += 'type=';
      }
      
      // Add status filter
      if (statusFilter != 'All Status') {
        if (queryParams.isNotEmpty && !queryParams.endsWith('&')) {
          queryParams += '&';
        }
        queryParams += 'status=${statusFilter.toLowerCase()}';
      } else {
        if (queryParams.isNotEmpty && !queryParams.endsWith('&')) {
          queryParams += '&';
        }
        queryParams += 'status=';
      }
      
      // Add date filter (optional - for future implementation)
      if (queryParams.isNotEmpty && !queryParams.endsWith('&')) {
        queryParams += '&';
      }
      queryParams += 'date_from=';
      
      final url = '${utilityUrl}transactions-filter?$queryParams';
      dev.log('Request URL: $url', name: 'HistoryScreen');

      final response = await apiService.getJsonRequest(url);

      response.fold(
        (failure) {
          dev.log('Failed to fetch transactions', name: 'HistoryScreen', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Transactions response received', name: 'HistoryScreen');
          if (data['success'] == 1) {
            _transactionHistory.value = TransactionHistoryModel.fromJson(data);
            // dev.log('transaction data: ${_transactionHistory.value?.transactions}');
            dev.log('Loaded ${_transactionHistory.value?.transactions.length ?? 0} transactions', name: 'HistoryScreen');
            Get.snackbar(
              'Success',
              data['message'] ?? 'Transactions loaded successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          } else {
            dev.log('Transaction fetch unsuccessful', name: 'HistoryScreen', error: data['message']);
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to load transactions',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching transactions', name: 'HistoryScreen', error: e);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      _isLoading.value = false;
      dev.log('Fetch transactions completed', name: 'HistoryScreen');
    }
  }

  // Refresh transactions
  Future<void> refreshTransactions() async {
    dev.log('Refreshing transactions...', name: 'HistoryScreen');
    await fetchTransactions();
    await fetchTransactionSummary();
  }

  // Get transaction icon based on type
  String getTransactionIcon(Transaction transaction) {
    final type = transaction.type.toLowerCase();
    final description = transaction.description.toLowerCase();

    String icon;
    if (type.contains('airtime') || description.contains('airtime')) {
      icon = AppAsset.mtn;
    } else if (type.contains('data') || description.contains('data')) {
      icon = AppAsset.mtn;
    } else if (type.contains('betting') || description.contains('betting')) {
      icon = AppAsset.betting;
    } else if (transaction.isCredit || type.contains('received')) {
      icon = AppAsset.received;
    } else if (type.contains('withdrawal') || description.contains('withdrawal')) {
      icon = AppAsset.withdrawal;
    } else {
      icon = AppAsset.mtn; // Default icon
    }
    
    // dev.log('Transaction icon for ${transaction.type}: $icon', name: 'HistoryScreen');
    return icon;
  }
}
