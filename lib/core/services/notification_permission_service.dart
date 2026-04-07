import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/styles/app_colors.dart';
import '../constants/fonts.dart';

class NotificationPermissionService {
  static final box = GetStorage();

  static const String _askedTsKey = 'notification_permission_asked_ts';
  static const String _rationaleShownTsKey =
      'notification_permission_rationale_shown_ts';
  
  static Future<void> ensurePermissionOnAppOpen({int coolDownDays = 7}) async {
    if (Get.context == null) return;

    final status = await Permission.notification.status;
    if (status.isGranted) {
      dev.log('Notification permission already granted',
          name: 'NotificationPermission');
      return;
    }

    final lastAsked = box.read(_askedTsKey);
    if (_isWithinCooldown(lastAsked, coolDownDays)) {
      dev.log('Notification permission asked recently, skipping',
          name: 'NotificationPermission');
      return;
    }

    await _requestSystemPermission();

    final afterRequest = await Permission.notification.status;
    if (afterRequest.isGranted) return;

    final lastRationale = box.read(_rationaleShownTsKey);
    if (_isWithinCooldown(lastRationale, coolDownDays)) {
      dev.log('Rationale shown recently, skipping',
          name: 'NotificationPermission');
      return;
    }

    _showRationaleDialog();
  }

  static Future<void> checkAndRequestPermission() async {
    await ensurePermissionOnAppOpen();
  }

  static bool _isWithinCooldown(dynamic storedIsoTs, int coolDownDays) {
    if (storedIsoTs == null) return false;
    final parsed = DateTime.tryParse(storedIsoTs.toString());
    if (parsed == null) return false;
    return DateTime.now().difference(parsed).inDays < coolDownDays;
  }

  static Future<void> _requestSystemPermission() async {
    box.write(_askedTsKey, DateTime.now().toIso8601String());

    final status = await Permission.notification.request();

    if (status.isGranted) {
      try {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      } catch (e) {
        dev.log('Error in FirebaseMessaging requestPermission: $e',
            name: 'NotificationPermission');
      }
    } else {
      dev.log('OS notification permission not granted: $status',
          name: 'NotificationPermission');
    }
  }

  static void _showRationaleDialog() {
    box.write(_rationaleShownTsKey, DateTime.now().toIso8601String());

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
                  "Enable Notifications",
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
                  "We use notifications to alert you about new Giveaways, giveaway claim updates, wallet deposits, and important transaction/security updates. You can always change this later in your device settings.",
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
                          _onRationaleAccept();
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
                          'Enable',
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
                          // user explicitly declined rationale
                          box.write(_askedTsKey, DateTime.now().toIso8601String());
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Close',
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

  static Future<void> _onRationaleAccept() async {
    final status = await Permission.notification.status;

    if (status.isPermanentlyDenied) {
      dev.log('Permission permanently denied; opening app settings',
          name: 'NotificationPermission');
      await openAppSettings();
      return;
    }

    // Try requesting again (some OEMs/flows show the prompt again)
    await _requestSystemPermission();
  }
}
