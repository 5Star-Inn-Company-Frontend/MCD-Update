import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/constants.dart';

class BusyButton extends StatelessWidget {
  const BusyButton({
    required this.title,
    required this.onTap,
    this.disabled = false,
    this.isLoading = false,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });
  final String title;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final VoidCallback onTap;
  final bool disabled;
  final bool isLoading;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled || isLoading ? null : onTap,
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(5),
          color: disabled || isLoading ? Colors.grey.shade400 : color,
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  color: AppColors.white,
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.manRope),
                ),
        ),
      ),
    );
  }
}
