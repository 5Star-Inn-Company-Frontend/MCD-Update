import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/constants.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'dart:developer' as dev;

class VerifyResetOtpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? email;
  const VerifyResetOtpScreen({super.key, this.phoneNumber, this.email});

  @override
  State<VerifyResetOtpScreen> createState() => _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState extends State<VerifyResetOtpScreen> {
  int minutes = 4;
  int seconds = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (minutes == 0 && seconds == 0) {
          timer.cancel();
        } else if (seconds == 0) {
          minutes -= 1;
          seconds = 59;
        } else {
          seconds -= 1;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final email = Get.arguments['email'];
    
    return Scaffold(
        appBar: const PaylonyAppBarTwo(title: ""),
        body: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold("Reset Password", fontSize: 20, fontWeight: FontWeight.w500,),
                const Gap(15),
                TextSemiBold("We’ve send you a one time verification code to ${email ?? widget.phoneNumber}"),
                const Gap(40),
                OTPTextField(
                  length: 5,
                  contentPadding: const EdgeInsets.symmetric(vertical: 25),
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 63,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: AppColors.boxColor,
                    borderColor: AppColors.white,
                    enabledBorderColor: Colors.transparent,
                  ),
                  style: const TextStyle(
                      fontSize: 17
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onChanged: (pin) {
                    dev.log("Changed: $pin");
                  },
                  onCompleted: (pin) {
                    dev.log("Completed: $pin");
                    authController.resetPasswordCheck(context, email!, pin);
                  },
                ),

                const Gap(40),
                TextSemiBold("Your 5 digit code is on its way. This can sometimes take a few moments to arrive.", color: AppColors.primaryGrey2,),
                const Gap(20),
                RichText(
                  text: TextSpan(
                    text: 'Resend code in ',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.manRope,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '$minutes:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.manRope,
                            color: AppColors.background
                        ),
                      ),
                    ],
                  ),
                  // textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  maxLines: 10,
                  textWidthBasis: TextWidthBasis.parent,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: true,
                    applyHeightToLastDescent: true,
                  ),
                  key: const Key('myRichTextWidgetKey'),
                ),

                // Spacer(),



              ],
            ),
          ),
        )

    );
  }
}