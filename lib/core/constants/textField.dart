import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/constants.dart';

final textInputDecoration = InputDecoration(
  fillColor: AppColors.inputFieldColor,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: AppColors.background, width: 1)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(width: 1, color: AppColors.background)),
  disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: AppColors.background, width: 1)),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 2,
        color: Colors.red,
      )),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 2,
        color: Colors.red,
      )),
  errorStyle: const TextStyle(
    // height: ,
    color: Colors.redAccent,
  ),
  labelStyle: const TextStyle(
    color: AppColors.labelTextColor,
  ),
  hintStyle: const TextStyle(
    color: Color(0xffB1B1B2),
    fontFamily: AppFonts.manRope,
    fontSize: 14.0,
  ),
);
