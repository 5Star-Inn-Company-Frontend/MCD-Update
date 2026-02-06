import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './jamb_verfy_account_module_controller.dart';

class JambVerfyAccountModulePage
    extends GetView<JambVerfyAccountModuleController> {
  const JambVerfyAccountModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const PaylonyAppBarTwo(
            title: "Verify Account",
            elevation: 0,
            centerTitle: false,
            actions: [],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'You will get ₦10 in your commission wallet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.background,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Gap(30),
                TextSemiBold(
                  "Enter profile code",
                  fontSize: 14,
                ),
                const Gap(8),
                TextFormField(
                  controller: controller.profileCodeController,
                  decoration: textInputDecoration.copyWith(
                    filled: true,
                    fillColor: const Color(0xffFFFFFF),
                    hintText: "Profile code",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.paste,
                          color: AppColors.primaryGrey2),
                      onPressed: controller.pasteFromClipboard,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xffD9D9D9).withOpacity(0.6))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor)),
                  ),
                ),
                const Gap(200),
                Center(
                  child: Obx(() => BusyButton(
                        width: screenWidth(context) * 0.6,
                        title: "Verify Account",
                        onTap: controller.verifyAccount,
                        disabled: controller.isLoading.value,
                      )),
                ),
              ],
            ),
          ),
        ),

        // Validation loading overlay
        Obx(() => controller.isValidating.value
            ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                        const Gap(20),
                        TextSemiBold(
                          "Validating...",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}
