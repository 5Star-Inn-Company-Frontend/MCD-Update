import 'package:flutter/services.dart';
import 'package:mcd/app/modules/new_device_verify_module/new_device_verify_controller.dart';
import 'package:mcd/core/import/imports.dart';

class NewDeviceVerifyPage extends GetView<NewDeviceVerifyController> {
  const NewDeviceVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'Verify New Device',
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                // // icon
                // Center(
                //   child: Container(
                //     width: 80,
                //     height: 80,
                //     decoration: BoxDecoration(
                //       color: AppColors.primaryColor.withOpacity(0.1),
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(
                //       Icons.security,
                //       size: 40,
                //       color: AppColors.primaryColor,
                //     ),
                //   ),
                // ),
                // const Gap(30),
                // title
                // Center(
                //   child: TextBold(
                //     'Device Verification',
                //     fontSize: 20,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // const Gap(12),
                // description
                Center(
                  child: Text(
                    'We sent an 8-digit verification code to your email. Enter the code below to verify this device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                ),
                const Gap(40),
                // code input
                TextSemiBold('Verification Code', fontSize: 14),
                const Gap(8),
                TextFormField(
                  controller: controller.codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 8,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 8,
                    fontFamily: AppFonts.manRope,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: InputDecoration(
                    hintText: '00000000',
                    hintStyle: TextStyle(
                      color: AppColors.primaryGrey.withOpacity(0.5),
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.primaryGrey.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code';
                    }
                    if (value.length != 8) {
                      return 'Code must be 8 digits';
                    }
                    return null;
                  },
                ),
                const Gap(30),
                // verify button
                Obx(() => BusyButton(
                      title: 'Verify Device',
                      onTap: controller.verifyCode,
                      isLoading: controller.isLoading.value,
                    )),
                const Gap(20),
                // resend code
                Center(
                  child: Obx(() => controller.isResending.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : TextButton(
                          onPressed: controller.resendCode,
                          child: RichText(
                            text: TextSpan(
                              text: "Didn't receive the code? ",
                              style: TextStyle(
                                color: AppColors.primaryGrey2,
                                fontFamily: AppFonts.manRope,
                                fontSize: 14,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Resend',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
