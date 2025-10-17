import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
              TextSemiBold(
                "This service is for people that want to make their NIN available for validation immediately without waiting for long. Enter the NIN and you will get response within 24hours",
              ),
              const Gap(4),
              TextSemiBold(
                "Enter the NIN and you will get response within 24hours",
                color: AppColors.background,
              ),
              const Gap(30),
              const Text(
                "Fee: ₦2,500",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const Gap(40),
              TextSemiBold(
                "Enter your/customer NIN",
                color: AppColors.background,
              ),
              const Gap(6),
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
              const Gap(20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        "You will receive a response within 24 hours after submission.",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(50),
              Center(
                child: Obx(() => BusyButton(
                  width: screenWidth(context) * 0.6,
                  title: "Submit",
                  onTap: controller.validateNin,
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