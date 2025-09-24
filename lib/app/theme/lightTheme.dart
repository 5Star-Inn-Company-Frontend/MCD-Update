import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.white,
  primaryColor: AppColors.white,
  applyElevationOverlayColor: false,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    // statusBarBrightness: Brightness.light,),

    // backgroundColor: AppColors.white,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: AppColors.textPrimaryColor,
  ),
);