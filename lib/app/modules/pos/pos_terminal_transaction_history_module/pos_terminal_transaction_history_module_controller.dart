import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTerminalTransactionHistoryModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  final transactions = <Map<String, String>>[
    {'date': '2023/10/01', 'time': '09:33', 'amount': '₦100,000.00', 'description': 'Cable TV Subscription', 'status': 'Successful', 'type': 'sent'},
    {'date': '2023/10/01', 'time': '10:32', 'amount': '₦200,000.00', 'description': 'Deposit', 'status': 'Failed', 'type': 'received'},
    {'date': '2023/10/03', 'time': '21:34', 'amount': '₦150,000.00', 'description': 'Payment', 'status': 'Successful', 'type': 'sent'},
    {'date': '2023/10/04', 'time': '01:13', 'amount': '₦50,000.00', 'description': 'Refund', 'status': 'Successful', 'type': 'received'},
    {'date': '2023/10/05', 'time': '09:33', 'amount': '₦100,000.00', 'description': 'Withdrawal', 'status': 'Failed', 'type': 'received'},
    {'date': '2023/10/05', 'time': '10:32', 'amount': '₦200,000.00', 'description': 'Deposit', 'status': 'Successful', 'type': 'received'},
    {'date': '2023/10/06', 'time': '21:34', 'amount': '₦150,000.00', 'description': 'Cable TV Subscription', 'status': 'Failed', 'type': 'sent'},
  ].obs;

  List<Map<String, String>> get filteredTransactions {
    if (searchQuery.value.isEmpty) {
      return transactions;
    } else {
      return transactions
          .where((transaction) =>
              transaction['description']!.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTerminalTransactionHistoryModuleController initialized', name: 'PosTerminalTransactionHistory');
  }

  @override
  void onClose() {
    dev.log('PosTerminalTransactionHistoryModuleController disposed', name: 'PosTerminalTransactionHistory');
    super.onClose();
  }
}
