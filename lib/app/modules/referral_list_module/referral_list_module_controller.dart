import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'package:mcd/core/network/api_constants.dart';

class ReferralListModuleController extends GetxController {
  final DioApiService apiService = DioApiService();

  final RxList<dynamic> referralList = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralList();
  }

  // fetch referral list from api
  Future<void> fetchReferralList() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result =
        await apiService.getrequest('${ApiConstants.authUrlV2}/referrals');
    dev.log('${ApiConstants.authUrlV2}/referrals');

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (data) {
        if (data['success'] == 1) {
          referralList.value = data['data'] ?? [];
        } else {
          errorMessage.value =
              data['message'] ?? 'Failed to fetch referral list';
        }
      },
    );

    isLoading.value = false;
  }

  // refresh referral list
  Future<void> refresh() async {
    await fetchReferralList();
  }
}
