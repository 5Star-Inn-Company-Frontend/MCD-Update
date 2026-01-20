import 'package:get/get.dart';
import 'package:mcd/app/modules/notification_module/model/notification_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class NotificationModuleController extends GetxController {
  final apiService = DioApiService();

  final notifications = <NotificationItem>[].obs;
  final groups = <String>[].obs;
  final selectedGroup = ''.obs; // empty = all
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // format group name for display
  String formatGroupName(String group) {
    if (group.isEmpty) return 'All';
    return group
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  // fetch notifications from api
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      String endpoint = '${ApiConstants.authUrlV2}/notifications';
      if (selectedGroup.value.isNotEmpty) {
        endpoint =
            '${ApiConstants.authUrlV2}/notifications/${selectedGroup.value}';
      }

      dev.log('Fetching notifications: $endpoint', name: 'Notifications');

      final result = await apiService.getrequest(endpoint);

      result.fold(
        (failure) {
          dev.log('Failed to fetch notifications: ${failure.message}',
              name: 'Notifications');
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('=== NOTIFICATIONS RAW RESPONSE ===', name: 'Notifications');
          dev.log('Full response: $data', name: 'Notifications');

          if (data['success'] == 1) {
            // parse groups
            if (data['groups'] != null) {
              groups.value = List<String>.from(data['groups']);
              dev.log('Groups: ${groups.value}', name: 'Notifications');
            }

            // parse notifications
            if (data['data'] != null && data['data']['data'] != null) {
              final rawItems = data['data']['data'] as List;
              dev.log('=== INDIVIDUAL NOTIFICATIONS ===',
                  name: 'Notifications');
              for (var i = 0; i < rawItems.length; i++) {
                dev.log('Notification [$i]: ${rawItems[i]}',
                    name: 'Notifications');
                dev.log('Actions [$i]: ${rawItems[i]['data']?['actions']}',
                    name: 'Notifications');
              }

              final items = rawItems
                  .map((item) => NotificationItem.fromJson(item))
                  .toList();
              notifications.assignAll(items);
              dev.log('Loaded ${items.length} notifications',
                  name: 'Notifications');
            } else {
              notifications.clear();
              dev.log('No notifications in response', name: 'Notifications');
            }
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching notifications: $e', name: 'Notifications');
    } finally {
      isLoading.value = false;
    }
  }

  // fetch unread count
  Future<void> fetchUnreadCount() async {
    try {
      final endpoint = '${ApiConstants.authUrlV2}/notifications-unread';
      dev.log('Fetching unread count: $endpoint', name: 'Notifications');

      final result = await apiService.getrequest(endpoint);

      result.fold(
        (failure) =>
            dev.log('Failed to fetch unread count', name: 'Notifications'),
        (data) {
          if (data['success'] == 1 && data['data'] != null) {
            unreadCount.value = data['data'] is int ? data['data'] : 0;
          }
        },
      );
    } catch (e) {
      dev.log('Error fetching unread count: $e', name: 'Notifications');
    }
  }

  // mark all as read
  Future<void> markAllAsRead() async {
    try {
      final endpoint = '${ApiConstants.authUrlV2}/notification-markread';
      dev.log('Marking all as read: $endpoint', name: 'Notifications');

      final result = await apiService.getrequest(endpoint);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          if (data['success'] == 1) {
            Get.snackbar(
              'Success',
              data['message'] ?? 'Marked all as read',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            unreadCount.value = 0;
            // refresh to update read status
            fetchNotifications();
          }
        },
      );
    } catch (e) {
      dev.log('Error marking as read: $e', name: 'Notifications');
    }
  }

  // filter by group
  void onGroupSelected(String group) {
    if (selectedGroup.value == group) return;
    selectedGroup.value = group;
    fetchNotifications();
  }
}
