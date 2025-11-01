import 'package:get/get.dart';
import 'package:mcd/core/constants/app_asset.dart';

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
  final _filterBy = 'All Time'.obs;
  String get filterBy => _filterBy.value;
  set filterBy(String value) => _filterBy.value = value;

  final _selectedValue = 'January'.obs;
  String get selectedValue => _selectedValue.value;
  set selectedValue(String value) => _selectedValue.value = value;

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

  final List<TransactionUIModel> transactionModel = <TransactionUIModel>[
    TransactionUIModel(
        name: "Betting Deposit",
        image: AppAsset.betting,
        amount: 1000,
        time: "1:10pm"),
    TransactionUIModel(
        name: "Airtime Topup",
        image: AppAsset.mtn,
        amount: 5000,
        time: "1:10pm"),
    TransactionUIModel(
        name: "Received from Akanji Joseph",
        image: AppAsset.withdrawal,
        amount: 21000,
        time: "1:10pm"),
    TransactionUIModel(
        name: "Withdrawal",
        image: AppAsset.received,
        amount: 1000,
        time: "1:10pm"),
    TransactionUIModel(
        name: "Data Bundle",
        image: AppAsset.mtn,
        amount: 1000,
        time: "1:10pm"),
  ];

  @override
  void onInit() {
    selectedValue = months.first;
    super.onInit();
  }
}
