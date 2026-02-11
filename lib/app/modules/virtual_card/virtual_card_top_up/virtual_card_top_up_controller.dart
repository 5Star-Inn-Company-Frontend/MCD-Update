import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/core/utils/amount_formatter.dart';
import 'dart:developer' as dev;

class VirtualCardTopUpController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  // global key for capturing receipt screenshot
  final receiptKey = GlobalKey();
  
  final enteredAmount = '0'.obs;
  final isDollar = true.obs;
  final exchangeRate = 1500.0.obs;
  final isFetchingRate = true.obs;
  final minAmount = 1.0;
  final maxAmount = 1500.0;
  final isTopping = false.obs;

  int? selectedCardId;
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['cardId'] != null) {
      selectedCardId = args['cardId'];
    }
    fetchExchangeRate();
  }

  Future<void> fetchExchangeRate() async {
    try {
      isFetchingRate.value = true;
      dev.log('Fetching exchange rate');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final result = await apiService.getrequest('${transactionUrl}virtual-card/list');

      result.fold(
        (failure) {
          dev.log('Error fetching rate: ${failure.message}');
        },
        (data) {
          if (data['success'] == 1 && data['rate'] != null) {
            exchangeRate.value = (data['rate'] ?? 1500.0).toDouble();
            dev.log('Exchange rate updated: ${exchangeRate.value}');
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
    } finally {
      isFetchingRate.value = false;
    }
  }
  
  void addDigit(String digit) {
    if (enteredAmount.value == "0") {
      enteredAmount.value = digit;
    } else {
      enteredAmount.value += digit;
    }
  }
  
  void removeDigit() {
    if (enteredAmount.value.isNotEmpty) {
      enteredAmount.value = enteredAmount.value.substring(0, enteredAmount.value.length - 1);
    }
    if (enteredAmount.value.isEmpty) {
      enteredAmount.value = "0";
    }
  }
  
  void toggleCurrency() {
    isDollar.value = !isDollar.value;
  }
  
  String get displayCurrency => isDollar.value ? "\$" : "₦";
  
  String get convertedAmount {
    final amount = double.tryParse(enteredAmount.value) ?? 0;
    if (isDollar.value) {
      final naira = amount * exchangeRate.value;
      return "₦${AmountUtil.formatFigure(naira)}";
    } else {
      final dollar = amount / exchangeRate.value;
      return "\$${AmountUtil.formatFigure(double.parse(dollar.toStringAsFixed(2)))}";
    }
  }

  String get rightSideDisplay {
    final amount = double.tryParse(enteredAmount.value) ?? 0;
    
    if (amount == 0) {
      // Show default exchange rate when no input
      return isDollar.value ? "₦${AmountUtil.formatFigure(exchangeRate.value)}" : "\$1";
    } else {
      // Show converted amount when user has input
      if (isDollar.value) {
        final naira = amount * exchangeRate.value;
        return "₦${AmountUtil.formatFigure(naira)}";
      } else {
        final dollar = amount / exchangeRate.value;
        return "\$${AmountUtil.formatFigure(double.parse(dollar.toStringAsFixed(2)))}";
      }
    }
  }

  String get formattedEnteredAmount {
    final amt = double.tryParse(enteredAmount.value) ?? 0;
    return AmountUtil.formatFigure(amt);
  }
  
  Future<void> topUpCard() async {
    final amount = double.tryParse(enteredAmount.value) ?? 0;
    
    if (amount < minAmount || amount > maxAmount) {
      Get.snackbar(
        'Error',
        'Amount must be between \$$minAmount and \$$maxAmount',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
      return;
    }

    if (selectedCardId == null) {
      Get.snackbar(
        'Error',
        'Card ID not found',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
      return;
    }
    
    try {
      isTopping.value = true;
      dev.log('Topping up card $selectedCardId with \$$amount');

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Error: Transaction URL not found');
        return;
      }

      final body = {'amount': amount};

      final result = await apiService.patchrequest(
        '${transactionUrl}virtual-card/topup/$selectedCardId',
        body,
      );

      result.fold(
        (failure) {
          dev.log('Error: ${failure.message}');
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
            colorText: const Color(0xFFF44336),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(20),
          );
        },
        (data) {
          if (data['success'] == 1) {
            dev.log('Success: ${data['message']}');
            Get.snackbar(
              'Success',
              data['message']?.toString() ?? 'Card topped up successfully',
              backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
              colorText: const Color(0xFF4CAF50),
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(20),
            );
            // Navigate to receipt screen with data
            Get.toNamed(
              Routes.VIRTUAL_CARD_RECEIPT,
              arguments: {
                'amount': amount,
                'timestamp': DateTime.now(),
                'currency': isDollar.value ? 'USD' : 'NGN',
              },
            );
          } else {
            dev.log('Error: ${data['message']}');
            Get.snackbar(
              'Error',
              data['message']?.toString() ?? 'Failed to top up card',
              backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
              colorText: const Color(0xFFF44336),
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(20),
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred',
        backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
        colorText: const Color(0xFFF44336),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
    } finally {
      isTopping.value = false;
    }
  }
}
