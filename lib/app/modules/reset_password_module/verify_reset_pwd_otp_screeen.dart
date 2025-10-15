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
                  controller.codeController.text = pin;
                },
                onCompleted: (pin) {
                  dev.log("Completed: $pin");
                  controller.resetPasswordCheck(context, controller.emailController.text.trim(), pin);
                },
              ),

              const Gap(40),
              TextSemiBold("Your 6 digit code is on its way. This can sometimes take a few moments to arrive.", color: AppColors.primaryGrey2,),
              
              const Gap(20),
              Obx(() => RichText(
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
              )),

              // Spacer(),



            ],
          ),
        ),
      )
    );
  }
}