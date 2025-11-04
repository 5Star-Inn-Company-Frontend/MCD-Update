import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/leaderboard_module/models/leaderboard_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class LeaderboardModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;

  final _leaderboardData = Rxn<LeaderboardModel>();
  set leaderboardData(value) => _leaderboardData.value = value;
  LeaderboardModel? get leaderboardData => _leaderboardData.value;

  List<LeaderboardUser> get topThree {
    if (leaderboardData == null || leaderboardData!.leaderboard.isEmpty) {
      return [];
    }
    return leaderboardData!.leaderboard.take(3).toList();
  }

  List<LeaderboardUser> get remainingUsers {
    if (leaderboardData == null || leaderboardData!.leaderboard.length <= 3) {
      return [];
    }
    return leaderboardData!.leaderboard.skip(3).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLoading = true;
      dev.log("Fetching leaderboard...");

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

      final result = await apiService.getrequest('${utilityUrl}leaderboard');

      result.fold(
        (failure) {
          dev.log("Leaderboard fetch failed: ${failure.message}");
          Get.snackbar(
            "Error",
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log("Leaderboard data received: ${data.toString()}");
          leaderboardData = LeaderboardModel.fromJson(data);
          dev.log("Leaderboard loaded: ${leaderboardData?.leaderboard.length} users");
        },
      );
    } catch (e) {
      dev.log("Leaderboard fetch error: $e");
      Get.snackbar(
        "Error",
        "Failed to load leaderboard",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshLeaderboard() async {
    await fetchLeaderboard();
  }
}