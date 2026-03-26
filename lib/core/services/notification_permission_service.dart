import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/styles/app_colors.dart';
import '../constants/fonts.dart';

class NotificationPermissionService {
  static final box = GetStorage();

  /// main entry point to check and request permission
  static Future<void> checkAndRequestPermission() async {
    // Only for Android (specifically Android 13+)
    if (!Platform.isAndroid) return;

    // Check if we've already asked in this session or recently
    final lastAsked = box.read('notification_permission_asked_ts');
    if (lastAsked != null) {
      final lastAskedDate = DateTime.tryParse(lastAsked.toString());
      if (lastAskedDate != null &&
          DateTime.now().difference(lastAskedDate).inDays < 7) {
        dev.log('Notification permission already asked recently, skipping',
            name: 'NotificationPermission');
        return;
      }
    }

    // Check current status
    final status = await Permission.notification.status;
    if (status.isGranted) {
      dev.log('Notification permission already granted',
          name: 'NotificationPermission');
      return;
    }

    // If denied (but not permanently), show our custom dialog first
    if (status.isDenied || status.isLimited) {
      _showCustomPermissionDialog();
    }
  }

  static void _showCustomPermissionDialog() {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Illustration/Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 40,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  "Don't Miss Our Giveaways!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.manRope,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                const Text(
                  "Enable notifications to get instant alerts on our latest Giveaways, plus real-time updates for your transactions and wallet deposits. Don't miss your chance to win!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.manRope,
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                // Buttons
                Column(
                  children: [
                    // Enable Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _requestActualPermission();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Enable Now',
                          style: TextStyle(
                            fontFamily: AppFonts.manRope,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Maybe Later Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          // Record that we asked
                          box.write('notification_permission_asked_ts',
                              DateTime.now().toIso8601String());
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Maybe Later',
                          style: TextStyle(
                            fontFamily: AppFonts.manRope,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Future<void> _requestActualPermission() async {
    dev.log('Requesting actual system notification permission...',
        name: 'NotificationPermission');

    // record that we asked
    box.write(
        'notification_permission_asked_ts', DateTime.now().toIso8601String());

    final status = await Permission.notification.request();

    if (status.isGranted) {
      dev.log('System notification permission granted',
          name: 'NotificationPermission');
      // On Android, we should also call Firebase requestPermission for full setup
      try {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (e) {
        dev.log('Error in FirebaseMessaging requestPermission: $e');
      }
    } else if (status.isPermanentlyDenied) {
      dev.log('Notification permission permanently denied',
          name: 'NotificationPermission');
    }
  }
}
