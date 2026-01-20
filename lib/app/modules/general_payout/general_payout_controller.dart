import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/app_strings.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/core/controllers/payment_config_controller.dart';
import 'dart:developer' as dev;
import 'package:mcd/core/utils/amount_formatter.dart';
import 'package:paystack/paystack.dart';

enum PaymentType {
  airtime,
  data,
  electricity,
  cable,
  airtimePin,
  dataPin,
  epin,
  ninValidation,
  resultChecker,
  betting,
}

class GeneralPayoutController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  PaymentConfigController? _paymentConfig;

  // Common state
  late final PaymentType paymentType;
  late final Map<String, dynamic> paymentData;

  final selectedPaymentMethod = 1.obs;
  final isPaying = false.obs;
  final walletBalance = '0'.obs;
  final bonusBalance = '0'.obs;
  final pointsBalance = '0'.obs;
  final usePoints = false.obs;
  final promoCodeController = TextEditingController();

  // Payment method availability
  final paymentMethodStatus = <String, String>{}.obs;
  final paymentMethodDetails = <String, String>{}.obs;
  final isLoadingPaymentMethods = true.obs;

  // UI Data
  String serviceName = '';
  String serviceImage = '';
  RxList<Map<String, String>> detailsRows = <Map<String, String>>[].obs;

  // Cable-specific
  final isRenewalMode = false.obs;
  final showPackageSelection = false.obs;
  final cableMonthTabs = <String>[].obs;
  final selectedCableMonth = ''.obs;
  final cablePackages = <dynamic>[].obs;
  final selectedCablePackage = Rxn<dynamic>();
  final isLoadingPackages = false.obs;
  final cableBouquetDetails = <String, String>{}.obs;

  // Airtime-specific
  final isMultipleAirtime = false.obs;
  final multipleAirtimeList = <Map<String, dynamic>>[].obs;

  // Paystack keys
  String get paystackSecretKey =>
      'sk_live_f1287e078d04cc1049db9bbb46ea9395db795a9c';

  @override
  void onInit() {
    super.onInit();
    dev.log('GeneralPayoutController initialized', name: 'GeneralPayout');

    // Get payment config controller
    try {
      _paymentConfig = Get.find<PaymentConfigController>();
    } catch (e) {
      dev.log('PaymentConfigController not found, will fetch directly',
          name: 'GeneralPayout');
    }

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    paymentType = args['paymentType'] ?? PaymentType.airtime;
    paymentData = args['paymentData'] ?? {};

    _initializePaymentTypeData();
    fetchBalances();
    fetchPaymentMethodAvailability();
  }

  void _initializePaymentTypeData() {
    switch (paymentType) {
      case PaymentType.airtime:
        _initializeAirtimeData();
        break;
      case PaymentType.data:
        _initializeDataData();
        break;
      case PaymentType.electricity:
        _initializeElectricityData();
        break;
      case PaymentType.cable:
        _initializeCableData();
        break;
      case PaymentType.airtimePin:
        _initializeAirtimePinData();
        break;
      case PaymentType.dataPin:
        _initializeDataPinData();
        break;
      case PaymentType.epin:
        _initializeEpinData();
        break;
      case PaymentType.ninValidation:
        _initializeNinValidationData();
        break;
      case PaymentType.resultChecker:
        _initializeResultCheckerData();
        break;
      case PaymentType.betting:
        _initializeBettingData();
        break;
    }
  }

  void _initializeAirtimeData() {
    isMultipleAirtime.value = paymentData['isMultiple'] ?? false;

    if (isMultipleAirtime.value) {
      multipleAirtimeList.value =
          List<Map<String, dynamic>>.from(paymentData['multipleList'] ?? []);
      serviceName = 'Multiple Airtime';
      serviceImage = '';
    } else {
      serviceName =
          paymentData['provider']?.network?.toUpperCase() ?? 'Airtime';
      serviceImage = paymentData['networkImage'] ?? '';
      detailsRows.value = [
        {
          'label': 'Amount',
          'value':
              '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
        },
        {'label': 'Phone Number', 'value': paymentData['phoneNumber'] ?? 'N/A'},
        {'label': 'Network', 'value': serviceName},
      ];
    }
  }

  void _initializeDataData() {
    serviceName = paymentData['networkProvider']?.name?.toUpperCase() ?? 'Data';
    serviceImage = paymentData['networkImage'] ?? '';
    detailsRows.value = [
      {'label': 'Plan', 'value': paymentData['dataPlan']?.name ?? 'N/A'},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['dataPlan']?.price ?? '0').toString()) ?? 0)}'
      },
      {'label': 'Phone Number', 'value': paymentData['phoneNumber'] ?? 'N/A'},
      {'label': 'Network', 'value': serviceName},
    ];
  }

  void _initializeElectricityData() {
    serviceName = paymentData['provider']?.name ?? 'Electricity';
    serviceImage = paymentData['providerImage'] ?? '';
    detailsRows.value = [
      {'label': 'Biller Name', 'value': serviceName},
      {'label': 'Payment Type', 'value': paymentData['paymentType'] ?? 'N/A'},
      {'label': 'Account Name', 'value': paymentData['customerName'] ?? 'N/A'},
      {'label': 'Meter Number', 'value': paymentData['meterNumber'] ?? 'N/A'},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount']?.toString() ?? '0')) ?? 0)}'
      },
    ];
  }

  void _initializeCableData() {
    serviceName = paymentData['provider']?.name ?? 'Cable TV';
    serviceImage = paymentData['providerImage'] ?? '';
    detailsRows.value = [
      {'label': 'Account Name', 'value': paymentData['customerName'] ?? 'N/A'},
      {'label': 'Biller Name', 'value': serviceName},
      {
        'label': 'Smartcard Number',
        'value': paymentData['smartCardNumber'] ?? 'N/A'
      },
    ];

    // Cable bouquet details
    final bouquetDetails =
        paymentData['bouquetDetails'] as Map<String, dynamic>?;
    if (bouquetDetails != null) {
      cableBouquetDetails.value = {
        'currentBouquet': bouquetDetails['current_bouquet'] ?? 'N/A',
        'bouquetPrice':
            bouquetDetails['current_bouquet_price']?.toString() ?? '0',
        'dueDate': bouquetDetails['due_date'] ?? 'N/A',
        'status': bouquetDetails['status'] ?? 'Unknown',
        'renewalAmount': bouquetDetails['renewal_amount']?.toString() ?? '0',
        'currentBouquetCode':
            bouquetDetails['current_bouquet_code'] ?? 'UNKNOWN',
      };
    }

    // Initialize cable tabs
    cableMonthTabs.value = [
      '1 Month',
      '2 Month',
      '3 Month',
      '4 Month',
      '5 Month'
    ];
    selectedCableMonth.value = '1 Month';
  }

  void _initializeAirtimePinData() {
    serviceName = paymentData['networkName'] ?? 'Airtime PIN';
    serviceImage = paymentData['networkImage'] ?? '';
    detailsRows.value = [
      {'label': 'Network Type', 'value': serviceName},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
      },
      {'label': 'Quantity', 'value': paymentData['quantity'] ?? 'N/A'},
    ];
  }

  void _initializeDataPinData() {
    serviceName = paymentData['networkName'] ?? 'Data PIN';
    serviceImage = paymentData['networkImage'] ?? '';
    detailsRows.value = [
      {'label': 'Network Type', 'value': serviceName},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
      },
      {'label': 'Quantity', 'value': paymentData['quantity'] ?? 'N/A'},
    ];
  }

  void _initializeEpinData() {
    serviceName = 'E-PIN';
    serviceImage = paymentData['serviceImage'] ?? '';
    detailsRows.value = [
      {'label': 'Service', 'value': paymentData['serviceName'] ?? 'N/A'},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
      },
      {'label': 'Quantity', 'value': paymentData['quantity'] ?? 'N/A'},
    ];
  }

  void _initializeNinValidationData() {
    serviceName = 'NIN Validation';
    serviceImage = '';
    detailsRows.value = [
      {'label': 'Service', 'value': 'NIN Validation'},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
      },
      {'label': 'NIN', 'value': paymentData['nin'] ?? 'N/A'},
    ];
  }

  void _initializeResultCheckerData() {
    serviceName = 'Result Checker';
    serviceImage = '';
    detailsRows.value = [
      {'label': 'Exam Type', 'value': paymentData['examType'] ?? 'N/A'},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
      },
      {'label': 'Quantity', 'value': paymentData['quantity'] ?? 'N/A'},
    ];
  }

  void _initializeBettingData() {
    serviceName = paymentData['providerName'] ?? 'Betting';
    serviceImage = paymentData['providerImage'] ?? '';
    detailsRows.value = [
      {'label': 'Provider', 'value': paymentData['providerName'] ?? 'N/A'},
      {'label': 'User ID', 'value': paymentData['userId'] ?? 'N/A'},
      {'label': 'Customer Name', 'value': paymentData['customerName'] ?? 'N/A'},
      {
        'label': 'Amount',
        'value':
            '₦${AmountUtil.formatFigure(double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0)}'
      },
    ];
  }

  Future<void> fetchBalances() async {
    try {
      dev.log('Fetching balances...', name: 'GeneralPayout');

      final result =
          await apiService.getrequest('${ApiConstants.authUrlV2}/dashboard');
      result.fold(
        (failure) {
          dev.log('Failed to fetch balances',
              name: 'GeneralPayout', error: failure.message);
        },
        (data) {
          if (data['data'] != null && data['data']['balance'] != null) {
            walletBalance.value =
                data['data']['balance']['wallet']?.toString() ?? '0';
            bonusBalance.value =
                data['data']['balance']['bonus']?.toString() ?? '0';
            pointsBalance.value =
                data['data']['balance']['points']?.toString() ?? '0';
            dev.log('Balances fetched successfully', name: 'GeneralPayout');
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching balances', name: 'GeneralPayout', error: e);
    }
  }

  Future<void> fetchPaymentMethodAvailability() async {
    try {
      // Use PaymentConfigController if available
      if (_paymentConfig != null) {
        dev.log(
            'Using cached payment method availability from PaymentConfigController',
            name: 'GeneralPayout');

        paymentMethodStatus.value = _paymentConfig!.paymentMethodStatus;
        paymentMethodDetails.value = _paymentConfig!.paymentMethodDetails;

        dev.log('Payment method availability: $paymentMethodStatus',
            name: 'GeneralPayout');

        // If not loaded yet, trigger refresh
        if (paymentMethodStatus.isEmpty) {
          dev.log('Payment methods not loaded, refreshing...',
              name: 'GeneralPayout');
          isLoadingPaymentMethods.value = true;
          await _paymentConfig!.refresh();
          paymentMethodStatus.value = _paymentConfig!.paymentMethodStatus;
          paymentMethodDetails.value = _paymentConfig!.paymentMethodDetails;
          isLoadingPaymentMethods.value = false;
        }
        return;
      }

      // Fallback: Fetch directly if PaymentConfigController not available
      dev.log('Fetching payment method availability directly...',
          name: 'GeneralPayout');
      isLoadingPaymentMethods.value = true;

      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found',
            name: 'GeneralPayout', error: 'URL missing');
        isLoadingPaymentMethods.value = false;
        return;
      }

      final result =
          await apiService.getrequest('${transactionUrl}payment-methods');
      result.fold(
        (failure) {
          dev.log('Failed to fetch payment method availability',
              name: 'GeneralPayout', error: failure.message);
          isLoadingPaymentMethods.value = false;
        },
        (data) {
          if (data['success'] == 1 &&
              data['data'] != null &&
              data['data']['status'] != null) {
            final status = data['data']['status'] as Map<String, dynamic>;
            paymentMethodStatus.value =
                status.map((key, value) => MapEntry(key, value.toString()));
            dev.log('Payment method availability: $paymentMethodStatus',
                name: 'GeneralPayout');

            if (data['data']['details'] != null) {
              final details = data['data']['details'] as Map<String, dynamic>;
              paymentMethodDetails.value =
                  details.map((key, value) => MapEntry(key, value.toString()));

              if (details['paystack_public'] != null) {
                box.write('paystack_public_key', details['paystack_public']);
                dev.log(
                    'Paystack public key stored: ${details['paystack_public']}',
                    name: 'GeneralPayout');
              }
            }
          }
          isLoadingPaymentMethods.value = false;
        },
      );
    } catch (e) {
      dev.log('Error fetching payment method availability',
          name: 'GeneralPayout', error: e);
      isLoadingPaymentMethods.value = false;
    }
  }

  bool isPaymentMethodAvailable(String method) {
    final status = paymentMethodStatus[method];
    return status == '1';
  }

  String getPaymentMethodKey() {
    switch (selectedPaymentMethod.value) {
      case 1:
        return 'wallet';
      case 2:
        return 'pay_gm';
      case 3:
        return 'paystack';
      default:
        return 'wallet';
    }
  }

  String getPaymentMethodDisplayName() {
    switch (selectedPaymentMethod.value) {
      case 1:
        return 'MCD Wallet';
      case 2:
        return 'General Market';
      case 3:
        return 'Paystack';
      default:
        return 'MCD Wallet';
    }
  }

  void selectPaymentMethod(int? value) {
    if (value != null) {
      String methodKey;
      String methodName;

      switch (value) {
        case 1:
          methodKey = 'wallet';
          methodName = 'MCD Wallet';
          break;
        case 2:
          methodKey = 'pay_gm';
          methodName = 'General Market';
          break;
        case 3:
          methodKey = 'paystack';
          methodName = 'Paystack';
          break;
        default:
          return;
      }

      if (!isPaymentMethodAvailable(methodKey)) {
        dev.log('Payment method $methodKey is not available',
            name: 'GeneralPayout');
        Get.snackbar(
          'Unavailable',
          'This payment method is currently not available',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      selectedPaymentMethod.value = value;
      dev.log('Payment method selected: $methodName', name: 'GeneralPayout');
    }
  }

  void toggleUsePoints(bool value) {
    usePoints.value = value;
    dev.log('Use points toggled: $value', name: 'GeneralPayout');
  }

  void clearPromoCode() {
    promoCodeController.clear();
    dev.log('Promo code cleared', name: 'GeneralPayout');
  }

  // Cable-specific methods
  void selectRenewal() {
    isRenewalMode.value = true;
    showPackageSelection.value = false;
    dev.log('Renewal mode selected', name: 'GeneralPayout');
  }

  void selectNewPackage() {
    showPackageSelection.value = true;
    isRenewalMode.value = false;
    fetchCablePackages();
    dev.log('New package selection mode', name: 'GeneralPayout');
  }

  void onCableMonthSelected(String month) {
    selectedCableMonth.value = month;
    dev.log('Cable month selected: $month', name: 'GeneralPayout');
  }

  void onCablePackageSelected(dynamic package) {
    selectedCablePackage.value = package;
    dev.log(
        'Cable package selected: ${package['name']} - ₦${package['amount']}',
        name: 'GeneralPayout');
  }

  Future<void> fetchCablePackages() async {
    try {
      isLoadingPackages.value = true;
      final providerCode = paymentData['provider']?.code;
      if (providerCode == null) return;

      final transactionUrl = box.read('transaction_service_url');
      final url = '$transactionUrl' 'tv/$providerCode';

      final result = await apiService.getrequest(url);
      result.fold(
        (failure) {
          dev.log('Failed to fetch packages',
              name: 'GeneralPayout', error: failure.message);
        },
        (data) {
          cablePackages.value = List.from(data['data'] ?? []);
          dev.log('Loaded ${cablePackages.length} packages',
              name: 'GeneralPayout');
        },
      );
    } finally {
      isLoadingPackages.value = false;
    }
  }

  void confirmAndPay() async {
    isPaying.value = true;
    dev.log('Confirming payment for ${paymentType.name}',
        name: 'GeneralPayout');

    try {
      // Check if Paystack payment is selected
      if (selectedPaymentMethod.value == 3) {
        await _processPaystackPayment();
        return;
      }

      // Process other payment methods
      switch (paymentType) {
        case PaymentType.airtime:
          await _processAirtimePayment();
          break;
        case PaymentType.data:
          await _processDataPayment();
          break;
        case PaymentType.electricity:
          await _processElectricityPayment();
          break;
        case PaymentType.cable:
          await _processCablePayment();
          break;
        case PaymentType.airtimePin:
          await _processAirtimePinPayment();
          break;
        case PaymentType.dataPin:
          await _processDataPinPayment();
          break;
        case PaymentType.epin:
          await _processEpinPayment();
          break;
        case PaymentType.ninValidation:
          await _processNinValidationPayment();
          break;
        case PaymentType.resultChecker:
          await _processResultCheckerPayment();
          break;
        case PaymentType.betting:
          await _processBettingPayment();
          break;
      }
    } catch (e) {
      dev.log("Payment Error", name: 'GeneralPayout', error: e);
      Get.snackbar(
        "Payment Error",
        "An unexpected error occurred.",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isPaying.value = false;
    }
  }

  Future<void> _processAirtimePayment() async {
    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) return;

    if (isMultipleAirtime.value) {
      await _processMultipleAirtime(transactionUrl);
    } else {
      await _processSingleAirtime(transactionUrl);
    }
  }

  Future<void> _processSingleAirtime(String transactionUrl) async {
    final ref = AppStrings.ref;

    final provider = paymentData['provider'];
    final phoneNumber = paymentData['phoneNumber'];
    final amount = paymentData['amount'];

    final body = {
      "provider": provider?.network?.toUpperCase() ?? '',
      "amount": amount.toString(),
      "number": phoneNumber,
      "country": "NG",
      "payment": getPaymentMethodKey(),
      "promo": promoCodeController.text.trim().isEmpty
          ? "0"
          : promoCodeController.text.trim(),
      "ref": ref,
      "operatorID": int.tryParse(provider?.server ?? '0') ?? 0,
    };

    dev.log(
        'Single airtime payment - Provider: ${provider?.network}, Amount: ₦$amount, Phone: $phoneNumber',
        name: 'GeneralPayout');
    dev.log('Payment request body: $body', name: 'GeneralPayout');

    final result =
        await apiService.postrequest('${transactionUrl}airtime', body);
    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1) {
          final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
          final debitAmount = data['debitAmount'] ?? data['amount'] ?? amount;
          final transactionDate =
              data['date'] ?? data['created_at'] ?? data['timestamp'];
          final formattedDate = transactionDate != null
              ? transactionDate.toString()
              : DateTime.now()
                  .toIso8601String()
                  .substring(0, 19)
                  .replaceAll('T', ' ');

          dev.log('Payment successful. Transaction ID: $transactionId',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Airtime purchase successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.TRANSACTION_DETAIL_MODULE,
            arguments: {
              'name': "Airtime Top Up",
              'image': paymentData['networkImage'],
              'amount': double.tryParse(debitAmount.toString()) ?? 0.0,
              'paymentType': 'Airtime',
              'paymentMethod': getPaymentMethodKey(),
              'userId': phoneNumber,
              // 'customerName': provider?.network?.toUpperCase() ?? 'N/A',
              'transactionId': transactionId,
              // 'packageName': '${provider?.network ?? ''} Airtime',
              // 'token': 'N/A',
              'date': formattedDate,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processMultipleAirtime(String transactionUrl) async {
    if (multipleAirtimeList.isEmpty) {
      Get.snackbar("Error", "No numbers to process.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    dev.log(
        'Processing multiple airtime for ${multipleAirtimeList.length} numbers',
        name: 'GeneralPayout');

    final ref = AppStrings.ref;

    // Build data array for all recipients
    final dataArray = multipleAirtimeList.map((item) {
      final provider = item['provider'];
      final phoneNumber = item['phoneNumber'];
      final amount = item['amount'];

      return {
        "provider": provider?.network?.toUpperCase() ?? '',
        "amount": amount.toString(),
        "number": phoneNumber,
        "operatorID": int.tryParse(provider?.server ?? '0') ?? 0,
      };
    }).toList();

    final body = {
      "country": "NG",
      "payment": getPaymentMethodKey(),
      "promo": promoCodeController.text.trim().isEmpty
          ? "0"
          : promoCodeController.text.trim(),
      "ref": ref,
      "number": multipleAirtimeList.length.toString(),
      "data": dataArray,
    };

    dev.log('Multiple airtime request body: $body', name: 'GeneralPayout');
    final result =
        await apiService.postrequest('${transactionUrl}airtime-multiple', body);

    result.fold(
      (failure) {
        dev.log('Multiple airtime payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Multiple airtime response: $data', name: 'GeneralPayout');
        if (data['success'] == 1) {
          dev.log('Multiple airtime payment successful', name: 'GeneralPayout');
          Get.snackbar(
            "Success",
            data['message'] ??
                "${multipleAirtimeList.length} airtime purchase(s) completed successfully!",
            backgroundColor: AppColors.successBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 4),
          );

          // Navigate back to home
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(Routes.HOME_SCREEN);
          });
        } else {
          dev.log('Multiple airtime payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processDataPayment() async {
    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final ref = AppStrings.ref;

    final networkProvider = paymentData['networkProvider'];
    final dataPlan = paymentData['dataPlan'];
    final phoneNumber = paymentData['phoneNumber'];

    final body = {
      "coded": dataPlan?.coded ?? '',
      "number": phoneNumber,
      "payment": getPaymentMethodKey(),
      "promo": promoCodeController.text.trim().isEmpty
          ? "0"
          : promoCodeController.text.trim(),
      "ref": ref,
      "country": "NG"
    };

    dev.log(
        'Data payment - Provider: ${networkProvider?.name}, Plan: ${dataPlan?.name}, Phone: $phoneNumber',
        name: 'GeneralPayout');
    dev.log('Payment request body: $body', name: 'GeneralPayout');

    final result = await apiService.postrequest('${transactionUrl}data', body);
    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1) {
          final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
          final debitAmount =
              data['debitAmount'] ?? data['amount'] ?? dataPlan?.price;
          final transactionDate =
              data['date'] ?? data['created_at'] ?? data['timestamp'];
          final formattedDate = transactionDate != null
              ? transactionDate.toString()
              : DateTime.now()
                  .toIso8601String()
                  .substring(0, 19)
                  .replaceAll('T', ' ');

          dev.log('Payment successful. Transaction ID: $transactionId',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Data purchase successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.TRANSACTION_DETAIL_MODULE,
            arguments: {
              'name': dataPlan?.name ?? 'Data Top Up',
              'image': paymentData['networkImage'],
              'amount': double.tryParse(debitAmount.toString()) ?? 0.0,
              'paymentType': 'Data bundle',
              'paymentMethod': getPaymentMethodKey(),
              'userId': phoneNumber,
              'transactionId': transactionId,
              'date': formattedDate,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processElectricityPayment() async {
    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final ref = AppStrings.ref;

    final provider = paymentData['provider'];
    final meterNumber = paymentData['meterNumber'];
    final amount = paymentData['amount'];
    final paymentTypeStr = paymentData['paymentType'];
    final customerName = paymentData['customerName'];

    final body = {
      "provider": provider?.code?.toLowerCase() ?? '',
      "number": meterNumber,
      "amount": amount?.toString() ?? '',
      "payment": getPaymentMethodKey(),
      "promo": promoCodeController.text.trim().isEmpty
          ? "0"
          : promoCodeController.text.trim(),
      "ref": ref,
    };

    dev.log(
        'Electricity payment - Provider: ${provider?.name}, Amount: ₦$amount, Type: $paymentTypeStr',
        name: 'GeneralPayout');
    dev.log('Payment request body: $body', name: 'GeneralPayout');

    final result =
        await apiService.postrequest('${transactionUrl}electricity', body);
    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1 || data.containsKey('trnx_id')) {
          // Extract token for prepaid electricity
          String token = 'N/A';
          if (paymentTypeStr?.toLowerCase() == 'prepaid') {
            token = data['token']?.toString() ??
                data['data']?['token']?.toString() ??
                data['Token']?.toString() ??
                data['data']?['Token']?.toString() ??
                'N/A';
            dev.log('Token extracted for prepaid: $token',
                name: 'GeneralPayout');
          }

          final transactionDate =
              data['date'] ?? data['created_at'] ?? data['timestamp'];
          final formattedDate = transactionDate != null
              ? transactionDate.toString()
              : DateTime.now()
                  .toIso8601String()
                  .substring(0, 19)
                  .replaceAll('T', ' ');

          dev.log(
              'Payment successful. Transaction ID: ${data['trnx_id']}, Token: $token',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Electricity payment successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.TRANSACTION_DETAIL_MODULE,
            arguments: {
              'name': "${provider?.name ?? 'Electricity'} - $paymentTypeStr",
              'image':
                  paymentData['providerImage'] ?? 'assets/images/mcdlogo.png',
              'amount': amount,
              'paymentType': "Electricity",
              'paymentMethod': getPaymentMethodKey(),
              'userId': meterNumber,
              'paymentItem': paymentTypeStr,
              // 'customerName': customerName,
              'transactionId': data['trnx_id']?.toString() ?? ref,
              'packageName': paymentTypeStr,
              'token': token,
              'date': formattedDate,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processCablePayment() async {
    // Validation
    if (isRenewalMode.value) {
      // For renewal, check if we have valid bouquet information
      final currentBouquetCode =
          cableBouquetDetails['currentBouquetCode'] ?? 'UNKNOWN';
      if (currentBouquetCode == 'UNKNOWN') {
        dev.log('Payment failed: Cannot renew. Invalid bouquet information',
            name: 'GeneralPayout', error: 'Invalid bouquet');
        Get.snackbar("Error", "Cannot renew. Invalid bouquet information.",
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
        return;
      }
      dev.log(
          'Processing renewal for current bouquet: ${cableBouquetDetails['currentBouquet']}',
          name: 'GeneralPayout');
    } else if (!showPackageSelection.value ||
        selectedCablePackage.value == null) {
      dev.log('Payment failed: No package selected',
          name: 'GeneralPayout', error: 'Package missing');
      Get.snackbar("Error", "Please select a package.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

    final provider = paymentData['provider'];
    final smartCardNumber = paymentData['smartCardNumber'];
    final customerName = paymentData['customerName'];

    // Determine the package code, name, and amount to use
    String packageCode;
    String packageName;
    String packageAmount;

    if (isRenewalMode.value) {
      // For renewal, use the current bouquet code and renewal amount
      packageCode = cableBouquetDetails['currentBouquetCode'] ?? 'UNKNOWN';
      packageName = cableBouquetDetails['currentBouquet'] ?? 'N/A';
      packageAmount = cableBouquetDetails['renewalAmount'] ?? '0';
    } else {
      // For new subscription, use selected package
      packageCode = selectedCablePackage.value?.code ?? '';
      packageName = selectedCablePackage.value?.name ?? 'N/A';
      packageAmount = selectedCablePackage.value?.amount ?? '0';
    }

    final body = {
      "coded": packageCode,
      "number": smartCardNumber,
      "payment": getPaymentMethodKey(),
      "promo": promoCodeController.text.trim().isEmpty
          ? "0"
          : promoCodeController.text.trim(),
      "ref": ref,
    };

    dev.log(
        'Cable payment - Provider: ${provider?.name}, Package: $packageName, Amount: ₦$packageAmount, Renewal: ${isRenewalMode.value}',
        name: 'GeneralPayout');
    dev.log('Payment request body: $body', name: 'GeneralPayout');

    final result = await apiService.postrequest('${transactionUrl}tv', body);

    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1 || data.containsKey('trnx_id')) {
          dev.log('Payment successful. Transaction ID: ${data['trnx_id']}',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Cable subscription successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offAllNamed(
            Routes.CABLE_TRANSACTION_MODULE,
            arguments: {
              'providerName': provider?.name ?? 'Cable TV',
              'image': paymentData['providerImage'],
              'amount': double.tryParse(packageAmount) ?? 0.0,
              'paymentType': "Cable TV",
              'paymentMethod': getPaymentMethodDisplayName(),
              'userId': smartCardNumber,
              'customerName': customerName,
              'transactionId': data['trnx_id']?.toString() ?? ref,
              'packageName': packageName,
              'isRenewal': isRenewalMode.value,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processAirtimePinPayment() async {
    dev.log('Processing airtime PIN payment...', name: 'GeneralPayout');

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

    final body = {
      'provider': paymentData['networkCode']?.toUpperCase() ?? '',
      'amount': paymentData['amount'] ?? '',
      'quantity': paymentData['quantity'] ?? '1',
      'payment': getPaymentMethodKey(),
      'promo':
          promoCodeController.text.isNotEmpty ? promoCodeController.text : '0',
      'ref': ref,
    };

    dev.log('Airtime Pin request body: $body', name: 'GeneralPayout');
    final response =
        await apiService.postrequest('${transactionUrl}airtimepin', body);

    response.fold(
      (failure) {
        dev.log('Airtime Pin payment failed: ${failure.message}',
            name: 'GeneralPayout');
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Airtime Pin payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1) {
          final transactionId = data['ref'] ?? data['trnx_id'] ?? ref;
          final token = data['token'] ?? 'N/A';
          final formattedDate = DateTime.now()
              .toIso8601String()
              .substring(0, 19)
              .replaceAll('T', ' ');

          dev.log(
              'Airtime Pin payment successful. Transaction ID: $transactionId',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Airtime Pin purchase successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.EPIN_TRANSACTION_DETAIL,
            arguments: {
              'networkName': paymentData['networkName'] ?? '',
              'networkImage': paymentData['networkImage'] ?? '',
              'amount': paymentData['amount'] ?? '',
              'designType': '2',
              'quantity': paymentData['quantity'] ?? '1',
              'paymentMethod': getPaymentMethodDisplayName(),
              'transactionId': transactionId,
              'postedDate': formattedDate,
              'transactionDate': formattedDate,
              'token': token,
            },
          );
        } else {
          Get.snackbar(
              "Payment Failed",
              data['message'] ??
                  "Airtime Pin purchase failed. Please try again.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processDataPinPayment() async {
    dev.log('Processing data PIN payment...', name: 'GeneralPayout');

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'mcd_${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

    final body = {
      "coded": paymentData['coded'] ?? '',
      "payment": getPaymentMethodKey(),
      "promo":
          promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
      "ref": ref,
      "country": "NG",
      "quantity": paymentData['quantity'] ?? '1',
    };

    dev.log('Data Pin payment request body: $body', name: 'GeneralPayout');
    final result =
        await apiService.postrequest('${transactionUrl}datapin', body);

    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1 || data['success'] == true) {
          final transactionId = data['ref'] ?? data['trnx_id'] ?? ref;
          final token = data['token'] ?? 'N/A';
          final formattedDate = DateTime.now()
              .toIso8601String()
              .substring(0, 19)
              .replaceAll('T', ' ');

          dev.log('Payment successful. Transaction ID: $transactionId',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Data Pin purchase successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.EPIN_TRANSACTION_DETAIL,
            arguments: {
              'networkName': paymentData['networkName'] ?? '',
              'networkImage': paymentData['networkImage'] ?? '',
              'amount': paymentData['amount'] ?? '',
              'designType': paymentData['designType'] ?? '',
              'quantity': paymentData['quantity'] ?? '1',
              'paymentMethod': getPaymentMethodDisplayName(),
              'transactionId': transactionId,
              'postedDate': formattedDate,
              'transactionDate': formattedDate,
              'token': token,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processEpinPayment() async {
    dev.log('Processing E-PIN payment...', name: 'GeneralPayout');

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'mcd_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

    final body = {
      "provider": paymentData['networkCode']?.toUpperCase() ?? '',
      "amount": paymentData['amount'] ?? '',
      "number": paymentData['recipient'] ?? '',
      "quantity": paymentData['quantity'] ?? '1',
      "payment": getPaymentMethodKey(),
      "promo":
          promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
      "ref": ref,
    };

    dev.log('E-pin payment request body: $body', name: 'GeneralPayout');
    final result =
        await apiService.postrequest('${transactionUrl}airtimepin', body);

    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        if (data['success'] == 1 || data['success'] == true) {
          final transactionId = data['ref'] ?? data['trnx_id'] ?? ref;
          final token = data['token'] ?? 'N/A';
          final formattedDate = DateTime.now()
              .toIso8601String()
              .substring(0, 19)
              .replaceAll('T', ' ');

          dev.log('Payment successful. Transaction ID: $transactionId',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "E-pin purchase successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.EPIN_TRANSACTION_DETAIL,
            arguments: {
              'networkName': paymentData['networkName'] ?? '',
              'networkImage': paymentData['networkImage'] ?? '',
              'amount': paymentData['amount'] ?? '',
              'designType': paymentData['designType'] ?? 'Standard',
              'quantity': paymentData['quantity'] ?? '1',
              'paymentMethod': getPaymentMethodDisplayName(),
              'transactionId': transactionId,
              'postedDate': formattedDate,
              'transactionDate': formattedDate,
              'token': token,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  Future<void> _processNinValidationPayment() async {
    dev.log('Processing NIN validation payment...', name: 'GeneralPayout');

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'mcd_${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

    final body = {
      "number": paymentData['ninNumber'] ?? '',
      "ref": ref,
      "payment": getPaymentMethodKey(),
      "promo":
          promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
    };

    dev.log('NIN validation payment request body: $body',
        name: 'GeneralPayout');
    final result =
        await apiService.postrequest('${transactionUrl}ninvalidation', body);

    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        final transactionId = data['data']?['transaction_id'] ?? ref;
        final formattedDate = DateTime.now()
            .toIso8601String()
            .substring(0, 19)
            .replaceAll('T', ' ');

        dev.log('Payment successful. Transaction ID: $transactionId',
            name: 'GeneralPayout');
        Get.snackbar("Success",
            data['message'] ?? "NIN validation request submitted successfully!",
            backgroundColor: AppColors.successBgColor,
            colorText: AppColors.textSnackbarColor);

        Get.offNamed(
          Routes.TRANSACTION_DETAIL_MODULE,
          arguments: {
            'name': "NIN Validation",
            'image': 'assets/images/nin_icon.png',
            'amount':
                double.tryParse(paymentData['amount'] ?? '2500') ?? 2500.0,
            'paymentType': "NIN Validation",
            'paymentMethod': getPaymentMethodDisplayName(),
            'userId': paymentData['ninNumber'] ?? '',
            'customerName': 'N/A',
            'transactionId': transactionId,
            'packageName': 'Standard Validation',
            'token': 'Check your email within 24 hours',
            'date': formattedDate,
          },
        );
      },
    );
  }

  Future<void> _processResultCheckerPayment() async {
    dev.log('Processing result checker payment...', name: 'GeneralPayout');

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'mcd_${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

    final body = {
      "coded": paymentData['examCode']?.toUpperCase() ?? '',
      "quantity": paymentData['quantity'] ?? '1',
      "ref": ref,
      "number": "0",
      "payment": getPaymentMethodKey(),
      "promo":
          promoCodeController.text.isEmpty ? "0" : promoCodeController.text,
    };

    dev.log('Result Checker payment request body: $body',
        name: 'GeneralPayout');
    final result =
        await apiService.postrequest('${transactionUrl}resultchecker', body);

    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: $data', name: 'GeneralPayout');
        final transactionId = data['data']?['transaction_id'] ?? ref;
        final token = data['data']?['token'] ?? 'Check your email';
        final formattedDate = DateTime.now()
            .toIso8601String()
            .substring(0, 19)
            .replaceAll('T', ' ');

        dev.log('Payment successful. Transaction ID: $transactionId',
            name: 'GeneralPayout');
        Get.snackbar(
            "Success",
            data['message'] ??
                "Result Checker purchase successful! Check your email.",
            backgroundColor: AppColors.successBgColor,
            colorText: AppColors.textSnackbarColor);

        Get.offNamed(
          Routes.TRANSACTION_DETAIL_MODULE,
          arguments: {
            'name': "Result Checker Token",
            'image': paymentData['examLogo'] ?? '',
            'amount': double.tryParse(paymentData['amount'] ?? '0') ?? 0.0,
            'paymentType': "Result Checker",
            'paymentMethod': getPaymentMethodDisplayName(),
            'userId': 'N/A',
            'customerName': paymentData['examName'] ?? '',
            'transactionId': transactionId,
            'packageName': paymentData['examName'] ?? '',
            'token': token,
            'date': formattedDate,
          },
        );
      },
    );
  }

  // void _navigateToTransactionDetail(Map<String, dynamic> data, String ref, {bool includeToken = false}) {
  //   if (data['success'] == 1 || data.containsKey('trnx_id')) {
  //     String? token;
  //     if (includeToken) {
  //       token = data['token']?.toString() ??
  //               data['data']?['token']?.toString() ??
  //               data['Token']?.toString() ??
  //               'N/A';
  //     }
  //     Get.snackbar("Success", data['message'] ?? "Payment successful!",
  //         backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
  //     Get.offNamed(
  //       Routes.TRANSACTION_DETAIL_MODULE,
  //       arguments: {
  //         'name': serviceName,
  //         'image': serviceImage,
  //         'amount': paymentData['amount'],
  //         'paymentType': paymentType.name,
  //         'paymentMethod': selectedPaymentMethod.value == 1 ? "wallet" : "mega_bonus",
  //         'transactionId': data['trnx_id']?.toString() ?? ref,
  //         'date': data['date'] ?? data['created_at'] ?? DateTime.now().toIso8601String(),
  //         if (token != null) 'token': token,
  //         ...paymentData,
  //       },
  //     );
  //   } else {
  //     Get.snackbar("Payment Failed", data['message'] ?? "An unknown error occurred.",
  //         backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
  //   }
  // }

  Future<void> _processPaystackPayment() async {
    try {
      dev.log('Processing Paystack payment...', name: 'GeneralPayout');

      // Get payment amount based on payment type
      double amount = 0;
      if (isMultipleAirtime.value) {
        amount = multipleAirtimeList.fold<double>(
            0, (sum, item) => sum + double.parse(item['amount']));
      } else {
        amount =
            double.tryParse((paymentData['amount'] ?? '0').toString()) ?? 0;

        // For cable, check if renewal or new package
        if (paymentType == PaymentType.cable) {
          if (isRenewalMode.value) {
            amount =
                double.tryParse(cableBouquetDetails['renewalAmount'] ?? '0') ??
                    0;
          } else if (selectedCablePackage.value != null) {
            amount = double.tryParse(
                    (selectedCablePackage.value['amount'] ?? '0').toString()) ??
                0;
          }
        }

        // For data, get plan price
        if (paymentType == PaymentType.data) {
          amount = double.tryParse(
                  (paymentData['dataPlan']?.price ?? '0').toString()) ??
              0;
        }
      }

      if (amount <= 0) {
        isPaying.value = false;
        Get.snackbar(
          'Error',
          'Invalid payment amount',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      dev.log('Initiating Paystack payment for ₦$amount',
          name: 'GeneralPayout');

      // Get user email
      final userEmail = box.read('user_email') ?? 'user@mcd.com';

      // Initialize Paystack client
      final paystackClient = PaystackClient(secretKey: paystackSecretKey);

      // Initialize transaction
      dev.log('Initializing Paystack transaction...', name: 'GeneralPayout');

      final response = await paystackClient.transactions.initialize(
        (amount * 100).toInt(), // Convert to kobo
        userEmail,
      );

      dev.log('Response data: ${response.data}', name: 'GeneralPayout');

      if (response.data != null) {
        // The actual data is nested inside response.data['data']
        final responseData = response.data['data'] as Map<String, dynamic>?;

        if (responseData == null) {
          isPaying.value = false;
          dev.log('Error: Response data is null', name: 'GeneralPayout');
          Get.snackbar(
            'Error',
            'Failed to initialize payment. Please try again.',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
          return;
        }

        final reference = responseData['reference'] as String?;
        final authorizationUrl = responseData['authorization_url'] as String?;

        if (reference == null || authorizationUrl == null) {
          isPaying.value = false;
          dev.log('Error: Missing reference or authorization URL',
              name: 'GeneralPayout');
          Get.snackbar(
            'Error',
            'Failed to initialize payment. Please try again.',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
          return;
        }

        dev.log('Transaction initialized with reference: $reference',
            name: 'GeneralPayout');

        // Log transaction to backend BEFORE opening payment page
        final transactionUrl = box.read('transaction_service_url');
        if (transactionUrl != null) {
          final fundBody = {
            'amount': amount.toString(),
            'ref': reference,
            'medium': 'paystack',
          };

          dev.log('Logging transaction to backend: $fundBody',
              name: 'GeneralPayout');
          await apiService.postrequest('${transactionUrl}fundwallet', fundBody);
        }

        isPaying.value = false;

        // Open payment screen
        final result = await Get.toNamed(
          Routes.PAYSTACK_PAYMENT,
          arguments: {
            'url': authorizationUrl,
            'reference': reference,
          },
        );

        // Verify transaction after payment
        if (result != null && result == true) {
          isPaying.value = true;
          await _verifyPaystackTransaction(reference, paystackClient);
        } else {
          Get.snackbar(
            'Payment Cancelled',
            'Transaction was not completed',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        }
      } else {
        isPaying.value = false;
        Get.snackbar(
          'Error',
          'Failed to initialize transaction',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
      }
    } catch (e) {
      isPaying.value = false;
      dev.log('Error processing Paystack payment',
          name: 'GeneralPayout', error: e);
      Get.snackbar(
        'Error',
        'Failed to process payment: ${e.toString()}',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    }
  }

  Future<void> _verifyPaystackTransaction(
      String reference, PaystackClient client) async {
    try {
      dev.log('Verifying transaction: $reference', name: 'GeneralPayout');

      final verifyResponse = await client.transactions.verify(reference);

      dev.log('Verify response data: ${verifyResponse.data}',
          name: 'GeneralPayout');

      if (verifyResponse.data != null) {
        // The actual data is nested inside verifyResponse.data['data']
        final responseData =
            verifyResponse.data['data'] as Map<String, dynamic>?;

        if (responseData != null) {
          final transactionStatus = responseData['status'] as String?;

          if (transactionStatus == 'success') {
            dev.log('Transaction verified successfully', name: 'GeneralPayout');
            dev.log(
                'Paystack payment successful. Wallet has been credited. Now processing service with wallet payment...',
                name: 'GeneralPayout');

            // Paystack payment successful, wallet credited
            // Now switch to wallet payment method for the actual service purchase
            final originalPaymentMethod = selectedPaymentMethod.value;
            selectedPaymentMethod.value =
                1; // Use wallet (since Paystack already funded it)

            // Process the service payment using wallet
            switch (paymentType) {
              case PaymentType.airtime:
                await _processAirtimePayment();
                break;
              case PaymentType.data:
                await _processDataPayment();
                break;
              case PaymentType.electricity:
                await _processElectricityPayment();
                break;
              case PaymentType.cable:
                await _processCablePayment();
                break;
              case PaymentType.airtimePin:
                await _processAirtimePinPayment();
                break;
              case PaymentType.dataPin:
                await _processDataPinPayment();
                break;
              case PaymentType.epin:
                await _processEpinPayment();
                break;
              case PaymentType.ninValidation:
                await _processNinValidationPayment();
                break;
              case PaymentType.resultChecker:
                await _processResultCheckerPayment();
                break;
              case PaymentType.betting:
                await _processBettingPayment();
                break;
            }

            // Restore original payment method selection
            selectedPaymentMethod.value = originalPaymentMethod;
          } else {
            isPaying.value = false;
            Get.snackbar(
              'Payment Failed',
              'Transaction was not successful',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        } else {
          isPaying.value = false;
          Get.snackbar(
            'Error',
            'Failed to verify transaction',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        }
      }
    } catch (e) {
      isPaying.value = false;
      dev.log('Error verifying Paystack transaction',
          name: 'GeneralPayout', error: e);
      Get.snackbar(
        'Error',
        'Failed to verify payment: ${e.toString()}',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    }
  }

  Future<void> _processBettingPayment() async {
    dev.log('Processing betting payment...', name: 'GeneralPayout');

    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'GeneralPayout', error: 'URL missing');
      Get.snackbar("Error", "Transaction URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor);
      return;
    }

    final username = box.read('biometric_username') ?? 'UN';
    final userPrefix = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    final ref = 'MCD2_\${userPrefix}${DateTime.now().microsecondsSinceEpoch}';

    final body = {
      "provider": paymentData['providerCode']?.toUpperCase() ?? '',
      "number": paymentData['userId'] ?? '',
      "amount": paymentData['amount']?.toString() ?? '0',
      "payment": getPaymentMethodKey(),
      "promo": promoCodeController.text.trim().isEmpty
          ? "0"
          : promoCodeController.text.trim(),
      "ref": ref,
    };

    dev.log('Betting payment request body: \$body', name: 'GeneralPayout');
    final result =
        await apiService.postrequest('\${transactionUrl}betting', body);

    result.fold(
      (failure) {
        dev.log('Payment failed',
            name: 'GeneralPayout', error: failure.message);
        Get.snackbar("Payment Failed", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log('Payment response: \$data', name: 'GeneralPayout');
        if (data['success'] == 1) {
          final transactionId = data['ref'] ?? data['trnx_id'] ?? 'N/A';
          final debitAmount =
              data['debitAmount'] ?? data['amount'] ?? paymentData['amount'];
          final transactionDate =
              data['date'] ?? data['created_at'] ?? data['timestamp'];
          final formattedDate = transactionDate != null
              ? transactionDate.toString()
              : DateTime.now()
                  .toIso8601String()
                  .substring(0, 19)
                  .replaceAll('T', ' ');

          dev.log('Payment successful. Transaction ID: \$transactionId',
              name: 'GeneralPayout');
          Get.snackbar(
              "Success", data['message'] ?? "Betting deposit successful!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor);

          Get.offNamed(
            Routes.TRANSACTION_DETAIL_MODULE,
            arguments: {
              'name': "Betting Deposit",
              'image': paymentData['providerImage'] ?? '',
              'amount': double.tryParse(debitAmount.toString()) ?? 0.0,
              'paymentType': "Betting",
              'paymentMethod': getPaymentMethodDisplayName(),
              'userId': paymentData['userId'] ?? 'N/A',
              'customerName': paymentData['customerName'] ??
                  paymentData['providerName'] ??
                  'N/A',
              'transactionId': transactionId,
              'packageName':
                  '${paymentData['providerName'] ?? 'Betting'} Deposit',
              'token': 'N/A',
              'date': formattedDate,
            },
          );
        } else {
          dev.log('Payment unsuccessful',
              name: 'GeneralPayout', error: data['message']);
          Get.snackbar(
              "Payment Failed", data['message'] ?? "An unknown error occurred.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor);
        }
      },
    );
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }
}
