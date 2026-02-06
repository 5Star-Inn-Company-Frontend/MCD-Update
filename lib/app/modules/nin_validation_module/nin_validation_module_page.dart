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
import './nin_validation_module_controller.dart';

class NinValidationModulePage extends GetView<NinValidationModuleController> {
  const NinValidationModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "NIN Validation",
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Do a quick check to confirm identity.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const Gap(8),
              Text(
                "Fill out the form below with the NIN and you will get response instantly",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const Gap(30),
              Text(
                "Fee: ₦100",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Gap(40),
              TextSemiBold(
                "Enter your/customer NIN",
                fontSize: 14,
              ),
              const Gap(8),
              TextFormField(
                controller: controller.ninController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a NIN number";
                  }
                  if (value.length != 11) {
                    return "NIN must be 11 digits";
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "NIN must contain only numbers";
                  }
                  return null;
                },
                decoration: textInputDecoration.copyWith(
                  filled: true,
                  fillColor: const Color(0xffFFFFFF),
                  hintText: "0123456789",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xffD9D9D9).withOpacity(0.6),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color(0xffD9D9D9).withOpacity(0.6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const Gap(70),
              Center(
                child: Obx(() => BusyButton(
                      width: screenWidth(context) * 0.6,
                      title: "Submit",
                      onTap: controller.proceedToPayout,
                      isLoading: controller.isValidating.value,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
