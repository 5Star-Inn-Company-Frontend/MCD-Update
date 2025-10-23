import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

/// GetX Template Generator - fb.com/htngu.99
///

class VerifyResetPwdOtpPage extends GetView<ResetPasswordController> {
  const VerifyResetPwdOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold("Reset Password", fontSize: 20, fontWeight: FontWeight.w500,),
              
              const Gap(15),
              TextSemiBold("We’ve send you a one time verification code to ${controller.emailController.text}"),
              
              const Gap(40),
              OTPTextField(
                length: 6,
                contentPadding: const EdgeInsets.symmetric(vertical: 25),
                width: MediaQuery.of(context).size.width,
                fieldWidth: MediaQuery.of(context).size.width * 0.125,
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
                  dev.log("OTP Changed: $pin");
                  controller.codeController.text = pin;
                },
                onCompleted: (pin) {
                  dev.log("OTP Completed: $pin, verifying...");
                  controller.resetPasswordCheck(context, controller.emailController.text.trim(), pin);
                },
              ),

              const Gap(40),
              TextSemiBold("Your 6 digit code is on its way. This can sometimes take a few moments to arrive.", color: AppColors.primaryGrey2,),
              
              const Gap(20),
              Obx(() {
                // Show countdown and a Resend button when timer is 0:00
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                            text: '${controller.minutes.value} :${controller.seconds.value.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.manRope,
                                color: AppColors.background
                            ),
                          ),
                        ],
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    // Show resend button only when countdown reached 0:00
                    if (controller.canResend) ...[
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          // call resend; controller will restart the timer on success
                          controller.resendOtp(context, controller.emailController.text.trim());
                        },
                        child: TextSemiBold("Resend code"),
                      )
                    ]
                  ],
                );
              }),

              // Spacer(),



            ],
          ),
        ),
      )
    );
  }
}