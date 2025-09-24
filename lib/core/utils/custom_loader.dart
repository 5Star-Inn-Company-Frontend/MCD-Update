import 'package:flutter/material.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'package:mcd/app/styles/app_colors.dart';

class CustomerLoader extends StatelessWidget {
  final String? url;
  const CustomerLoader({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return LogoandSpinner(
    imageAssets: url ?? 'assets/icons/launcher_icon.png',
    reverse: true,
    arcColor: AppColors.primaryColor,
    spinSpeed: Duration(milliseconds: 500),
  );
  }
}