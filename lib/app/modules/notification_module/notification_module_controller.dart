import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';

class NotificationModel {
  final bool checked;
  final String message;
  final bool fundRequest;
  final String date;

  NotificationModel({
    required this.checked,
    required this.message,
    required this.fundRequest,
    required this.date,
  });
}

class NotificationModuleController extends GetxController {
  final List<NotificationModel> notifications = [
    NotificationModel(
      checked: false,
      message: 'New Account created',
      fundRequest: false,
      date: 'Today at 9:42 AM',
    ),
    NotificationModel(
      checked: false,
      message: 'Tesd requested for #500 from your wallet',
      fundRequest: true,
      date: 'Today at 9:42 AM',
    ),
    NotificationModel(
      checked: true,
      message: 'Dear Customer, Happy Friday!',
      fundRequest: false,
      date: 'Last Wednesday at 9:42 AM',
    ),
    NotificationModel(
      checked: true,
      message: 'Funding Update, Important Update on \nFunding Delays from Mega Cheap Data',
      fundRequest: false,
      date: '12 May 2024 at 9:42 AM',
    ),
  ];

  void approveRequest() {
    Get.snackbar("Approved", "Request approved successfully", backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
  }

  void declineRequest() {
    Get.snackbar("Declined", "Request declined", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
  }
}