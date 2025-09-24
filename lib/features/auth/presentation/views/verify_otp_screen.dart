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

class VerifyOtpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String email;
  const VerifyOtpScreen({super.key, this.phoneNumber, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  int minutes = 4;
  int seconds = 0;
  late Timer timer;
  bool _isVerifying = false;

  final controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
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

  Future<void> _resendCode() async {
    if (widget.email == null) return;

    final userData = controller.pendingSignupData;
    if (userData == null) return;

    try {
      await controller.sendCode(context, widget.email);
      setState(() {
        minutes = 4;
        seconds = 0;
        timer.cancel();
        startTimer();
      });
    } catch (e) {
      dev.log('Error resending code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error resending code')),
      );
    }
  }

  Future<void> _verifyCode(String code) async {
    if (_isVerifying) return;

    setState(() => _isVerifying = true);
    try {
      await controller.signup(context, code);
    } catch (e) {
      dev.log('Error verifying code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error verifying code')),
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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

              TextSemiBold("We've sent you a one time verification code to ${widget.email}"),
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
                  _verifyCode(pin);
                },
              ),
              const Gap(40),

              if (_isVerifying) const Center(child: CircularProgressIndicator()),
              TextSemiBold(
                "Your 8 digit code is on its way. This can sometimes take a few moments to arrive.",
                color: AppColors.primaryGrey2,
              ),

              const Gap(20),
              GestureDetector(
                onTap: minutes == 0 && seconds == 0 ? _resendCode : null,
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
                        text: '$minutes:${seconds.toString().padLeft(2, '0')}',
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
