import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/app_strings.dart';

class AppWidgets{
  final Widget logoIcon = SvgPicture.asset(
     AppAsset.logo,
      semanticsLabel: 'App logo'
  );
  final Widget appTextName  = TextSemiBold(
    AppStrings.appNAme,
    color: AppColors.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}