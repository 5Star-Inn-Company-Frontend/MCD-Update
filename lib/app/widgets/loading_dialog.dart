import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showLoadingDialog({String? lottie, BuildContext? context}) async {
  showDialog(
    context: context!,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: willpop,
      child: Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: LottieBuilder.asset(
            lottie ?? 'assets/images/loadingcubes.json',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
    ),
  );
}

Future<bool> willpop() async {
  return false;
}