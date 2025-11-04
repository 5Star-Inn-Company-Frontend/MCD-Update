import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/history_screen_module/models/transaction_history_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/network/dio_api_service.dart';

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
  set filterBy(String value) => _filterBy.value = value;

  final _statusFilter = 'All Status'.obs;
  String get statusFilter => _statusFilter.value;
  set statusFilter(String value) => _statusFilter.value = value;

  final _selectedValue = 'January'.obs;
  String get selectedValue => _selectedValue.value;
  set selectedValue(String value) => _selectedValue.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final Rxn<TransactionHistoryModel> _transactionHistory = Rxn<TransactionHistoryModel>();
  TransactionHistoryModel? get transactionHistory => _transactionHistory.value;

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

  // Filtered transactions based on selected filter
  List<Transaction> get filteredTransactions {
    if (transactionHistory == null) return [];
    
    var transactions = transactionHistory!.transactions;

    // Apply transaction type filter
    if (filterBy == 'Money in') {
      transactions = transactions.where((t) => t.isCredit).toList();
    } else if (filterBy == 'Money out') {
      transactions = transactions.where((t) => !t.isCredit).toList();
    }

    // Apply status filter if needed
    if (statusFilter != 'All Status') {
      transactions = transactions.where((t) => 
        t.status.toLowerCase() == statusFilter.toLowerCase()
      ).toList();
    }

    return transactions;
  }

  // Get total in for filtered month
  double get totalIn => transactionHistory?.totalIn ?? 0.0;

  // Get total out for filtered month
  double get totalOut => transactionHistory?.totalOut ?? 0.0;

  @override
  void onInit() {
    selectedValue = months.first;
    fetchTransactions();
    super.onInit();
  }

  // Fetch transactions from API
  Future<void> fetchTransactions() async {
    try {
      _isLoading.value = true;
      
      final utilityUrl = box.read('utility_service_url') ?? '';
      final url = '${utilityUrl}transactions';

      final response = await apiService.getJsonRequest(url);

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
            _transactionHistory.value = TransactionHistoryModel.fromJson(data);
            Get.snackbar(
              'Success',
              data['message'] ?? 'Transactions loaded successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          } else {
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
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Refresh transactions
  Future<void> refreshTransactions() async {
    await fetchTransactions();
  }

  // Get transaction icon based on type
  String getTransactionIcon(Transaction transaction) {
    final type = transaction.type.toLowerCase();
    final description = transaction.description.toLowerCase();

    if (type.contains('airtime') || description.contains('airtime')) {
      return AppAsset.mtn;
    } else if (type.contains('data') || description.contains('data')) {
      return AppAsset.mtn;
    } else if (type.contains('betting') || description.contains('betting')) {
      return AppAsset.betting;
    } else if (transaction.isCredit || type.contains('received')) {
      return AppAsset.received;
    } else if (type.contains('withdrawal') || description.contains('withdrawal')) {
      return AppAsset.withdrawal;
    }
    
    return AppAsset.mtn; // Default icon
  }
}
