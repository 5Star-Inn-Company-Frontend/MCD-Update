import 'package:get/get.dart';
import 'dart:developer' as dev;

class PosRequestNewTermModuleController extends GetxController {
  final selectedTerminalType = ''.obs;
  
  final terminals = [
    {
      'name': 'K11 Terminal',
      'image': 'assets/images/k11-terminal.png',
      'outrightPurchase': '130,000',
      'lease': '0',
      'installment': '140,000',
      'installmentInitial': '60,000',
      'repayment': '1,000',
      'frequency': 'Per day',
    },
    {
      'name': 'MP35P Terminal',
      'image': 'assets/images/mp35p-terminal.png',
      'outrightPurchase': '130,000',
      'lease': '0',
      'installment': '140,000',
      'installmentInitial': '60,000',
      'repayment': '1,000',
      'frequency': 'Per day',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    dev.log('PosRequestNewTermModuleController initialized', name: 'PosRequestNewTerm');
  }

  @override
  void onClose() {
    dev.log('PosRequestNewTermModuleController disposed', name: 'PosRequestNewTerm');
    super.onClose();
  }

  void selectTerminal(String terminalName) {
    selectedTerminalType.value = terminalName;
    Get.toNamed('/pos_term_req_form', arguments: {'terminalType': terminalName});
  }
}
