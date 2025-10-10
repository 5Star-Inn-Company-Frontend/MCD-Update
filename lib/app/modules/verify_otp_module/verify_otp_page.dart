import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/verify_otp_module/verify_otp_controller.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../core/constants/fonts.dart';
import '../../styles/app_colors.dart';
import '../../styles/fonts.dart';
import '../../widgets/app_bar-two.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class VerifyOtpPage extends GetView<VerifyOtpController> {
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold(
                // "Verify your ${widget.email != null ? 'email' : 'phone number'}",
                "Verify your email",
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              const Gap(15),
              TextSemiBold(
                  "We've sent you a one time verification code to ${controller.obj}"),
              const Gap(40),
              OTPTextField(
                length: 8,
                contentPadding: const EdgeInsets.symmetric(vertical: 25),
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor: AppColors.boxColor,
                  borderColor: AppColors.white,
                  enabledBorderColor: Colors.transparent,
                ),
                style: const TextStyle(fontSize: 17),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  dev.log("Completed: $pin");
                  Get.back(result: pin);
                },
              ),
              const Gap(40),
              if (controller.isVerifying)
                const Center(child: CircularProgressIndicator()),
              TextSemiBold(
                "Your 8 digit code is on its way. This can sometimes take a few moments to arrive.",
                color: AppColors.primaryGrey2,
              ),
              const Gap(20),
              GestureDetector(
                onTap: controller.minutes == 0 && controller.seconds == 0
                    ? controller.sendCode
                    : null,
                child: RichText(
                  text: TextSpan(
                    text: 'Resend code in ',
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.manRope,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${controller.minutes}:${controller.seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.manRope,
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
