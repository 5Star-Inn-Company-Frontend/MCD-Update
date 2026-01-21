import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/plans_module/models/plan_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PlansModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;

  final _isUpgrading = false.obs;
  set isUpgrading(value) => _isUpgrading.value = value;
  bool get isUpgrading => _isUpgrading.value;

  final _plans = <PlanModel>[].obs;
  set plans(value) => _plans.value = value;
  List<PlanModel> get plans => _plans;

  final _currentPlanIndex = 0.obs;
  set currentPlanIndex(value) => _currentPlanIndex.value = value;
  int get currentPlanIndex => _currentPlanIndex.value;

  PlanModel? get currentPlan =>
      plans.isNotEmpty && currentPlanIndex < plans.length
          ? plans[currentPlanIndex]
          : null;

  // user's actual subscription plan name (from storage)
  String get userCurrentPlan {
    final cachedDashboard = box.read('cached_dashboard');
    if (cachedDashboard != null && cachedDashboard['user'] != null) {
      return (cachedDashboard['user']['referral_plan'] ?? 'free')
          .toString()
          .toLowerCase();
    }
    return 'free';
  }

  // check if displayed plan is user's current plan
  bool isUserPlan(PlanModel plan) {
    return plan.name.toLowerCase() == userCurrentPlan;
  }

  // check if user can upgrade to this plan (plan is higher than current)
  bool canUpgradeTo(PlanModel plan) {
    final currentIndex =
        plans.indexWhere((p) => p.name.toLowerCase() == userCurrentPlan);
    final targetIndex = plans.indexOf(plan);
    return targetIndex > currentIndex;
  }

  final args = Get.arguments as Map<String, dynamic>?;

  dynamic get _isAppbar => args?['isAppbar'] ?? true.obs;
  bool get isAppbar => _isAppbar.value;
  set isAppbar(bool value) => _isAppbar.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading = true;
      dev.log("Fetching plans...");

      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null) {
        Get.snackbar(
          "Error",
          "Service URL not found. Please login again.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      final result = await apiService.getrequest('${utilityUrl}referralPlans');

      result.fold(
        (failure) {
          dev.log("Plans fetch failed: ${failure.message}");
          Get.snackbar(
            "Error",
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log("Plans data received: ${data.toString()}");
          final plansResponse = PlansResponse.fromJson(data);
          plans = plansResponse.plans;
          dev.log("Plans loaded: ${plans.length} plans");
        },
      );
    } catch (e) {
      dev.log("Plans fetch error: $e");
      Get.snackbar(
        "Error",
        "Failed to load plans",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoading = false;
    }
  }

  void onPageChanged(int index) {
    currentPlanIndex = index;
  }

  Future<void> upgradePlan(int planId) async {
    try {
      isUpgrading = true;
      dev.log("Upgrading to plan ID: $planId");

      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null) {
        Get.snackbar(
          "Error",
          "Service URL not found. Please login again.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      final body = {"id": planId};
      final result =
          await apiService.postrequest('${utilityUrl}user-upgrade', body);

      result.fold(
        (failure) {
          dev.log("Plan upgrade failed: ${failure.message}");
          Get.snackbar(
            "Upgrade Failed",
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log("Plan upgrade successful: ${data.toString()}");
          final upgradeResponse = UpgradePlanResponse.fromJson(data);
          Get.snackbar(
            "Success",
            upgradeResponse.message,
            backgroundColor: AppColors.successBgColor,
            colorText: AppColors.textSnackbarColor,
          );
          // Refresh plans after upgrade
          fetchPlans();
        },
      );
    } catch (e) {
      dev.log("Plan upgrade error: $e");
      Get.snackbar(
        "Error",
        "Failed to upgrade plan",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isUpgrading = false;
    }
  }
}
