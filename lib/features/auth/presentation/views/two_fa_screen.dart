import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'dart:developer' as dev;

class TwoFAScreen extends StatefulWidget {
  final String? email;
  const TwoFAScreen({super.key, this.email});

  @override
  State<TwoFAScreen> createState() => _TwoFAScreenState();
}

class _TwoFAScreenState extends State<TwoFAScreen> {
  int minutes = 4;
  int seconds = 0;
  late Timer timer;
  bool _isVerifying = false;

  final controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
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
                "Verify your 2FA",
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              const Gap(15),

              TextSemiBold("We've sent you a one time verification code to ${widget.email ?? 'your email'}"),
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
                "Your 5 digit code is on its way. This can sometimes take a few moments to arrive.",
                color: AppColors.primaryGrey2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
