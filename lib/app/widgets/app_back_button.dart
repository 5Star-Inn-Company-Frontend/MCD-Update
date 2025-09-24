import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';


class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.zero,
      child: Center(
        child: Icon(
          Icons.arrow_back,
          color: AppColors.primaryColor,
      )
      ),
    );
  }
}