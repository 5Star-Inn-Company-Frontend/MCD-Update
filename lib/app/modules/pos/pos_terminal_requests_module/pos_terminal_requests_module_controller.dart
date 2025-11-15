import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTerminalRequestsModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  
  final terminalRequests = <Map<String, String>>[
    {'date': '2023/10/01', 'time': '09:33', 'amount': '₦100,000.00', 'terminal_type': 'K11 Terminal', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/01', 'time': '10:32', 'amount': '₦200,000.00', 'terminal_type': 'Terminal 2', 'purchaseType': 'Other Purchase', },
    {'date': '2023/10/03', 'time': '21:34', 'amount': '₦150,000.00', 'terminal_type': 'Terminal Type 3', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/04', 'time': '01:13', 'amount': '₦50,000.00', 'terminal_type': 'K11 Terminal', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/05', 'time': '09:33', 'amount': '₦100,000.00', 'terminal_type': 'Terminal Type 3', 'purchaseType': 'Other Purchase', },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTerminalRequestsModuleController initialized', name: 'PosTerminalRequests');
  }

  @override
  void onClose() {
    dev.log('PosTerminalRequestsModuleController disposed', name: 'PosTerminalRequests');
    super.onClose();
  }
}
