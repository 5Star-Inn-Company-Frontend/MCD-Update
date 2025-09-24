
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';

class FlushbarNotification {
  static void showSuccessMessage(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    Flushbar(
      title: title ?? 'Success',
      message: message,
      margin: const EdgeInsets.symmetric(horizontal: 7),
      titleSize: 18,
      messageSize: 12,
      backgroundColor: AppColors.primaryGreen,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.bounceIn,
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showErrorMessage(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    Flushbar(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      title: title ?? 'Error!!',
      message: message,
      titleSize: 12,
      messageSize: 12,
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.bounceIn,
      duration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(12)
    ).show(context);
  }
}