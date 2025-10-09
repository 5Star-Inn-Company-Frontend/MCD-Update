import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_asset.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/textField.dart';
import '../../../core/utils/validator.dart';
import '../../../features/auth/presentation/views/biometrrics.dart';
import '../../routes/app_pages.dart';
import '../../styles/app_colors.dart';
import '../../styles/fonts.dart';
import '../../widgets/touchableOpacity.dart';
import 'login_screen_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class LoginScreenPage extends GetView<LoginScreenController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: BackButton(
            color: AppColors.primaryColor,
            onPressed: () {
              Get.toNamed(Routes.CREATEACCOUNT);
            },
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemiBold(
                          "Login or Create an account",
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        const Gap(15),

                        // email widget
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.isEmail = false;
                              },
                              child: AnimatedContainer(
                                decoration: BoxDecoration(
                                    color: !controller.isEmail
                                        ? AppColors.primaryColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: !controller.isEmail
                                            ? Colors.white
                                            : AppColors.background,
                                        width: !controller.isEmail ? 1 : 0.0)),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      'Phone',
                                      style: TextStyle(
                                          fontFamily: 'Merriweather',
                                          fontSize: 14,
                                          color: !controller.isEmail
                                              ? Colors.white
                                              : const Color(0xFF1D1D1D)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(15),
                            GestureDetector(
                              onTap: () {
                                controller.isEmail = true;
                              },
                              child: AnimatedContainer(
                                width: 80,
                                decoration: BoxDecoration(
                                    color: controller.isEmail
                                        ? AppColors.primaryColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: controller.isEmail
                                            ? Colors.white
                                            : AppColors.background,
                                        width: controller.isEmail ? 1.5 : 0.0)),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontFamily: AppFonts.manRope,
                                          fontSize: 14,
                                          color: controller.isEmail
                                              ? Colors.white
                                              : const Color(0xFF1D1D1D)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(25),

                        // email widget
                        controller.isEmail
                            ? TextFormField(
                                controller: controller.emailController,
                                validator: (value) {
                                  if (value == null &&
                                      controller.isEmail == true) {
                                    return "Input Email";
                                  }
                                  if (CustomValidator.validEmail(
                                              value!.trim()) ==
                                          false &&
                                      controller.isEmail == true) {
                                    return "Invalid Email";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  controller.setFormValidState();
                                },
                                textInputAction: TextInputAction.next,
                                decoration: textInputDecoration.copyWith(
                                    filled: false,
                                    hintText: "name@mail.com",
                                    hintStyle: const TextStyle(
                                        color: AppColors.primaryGrey2)),
                              )
                            : Column(
                                children: [
                                  controller.errorText == null
                                      ? Container()
                                      : TextSemiBold(
                                          controller.errorText.toString(),
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                          controller:
                                              controller.countryController,
                                          enabled: false,
                                          decoration:
                                              textInputDecoration.copyWith(
                                            filled: false,
                                          ),
                                        ),
                                      ),
                                      const Gap(15),
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          controller:
                                              controller.phoneNumberController,
                                          onChanged: (value) {
                                            controller.validateInput(value);
                                            controller.setFormValidState();
                                          },
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: textInputDecoration
                                              .copyWith(filled: false),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        const Gap(25),

                        // password widget
                        TextFormField(
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordVisible,
                            validator: (value) {
                              if (value == null) return "Input password";
                              if (value.length < 6) {
                                return "Password must contain 6 characters";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              controller.setFormValidState();
                              controller.validateInput(value);
                            },
                            obscuringCharacter: '*',
                            decoration: textInputDecoration.copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              fillColor: AppColors.white,
                              hintText: "**************",
                              hintStyle: const TextStyle(
                                  color: AppColors.primaryGrey2,
                                  fontSize: 20,
                                  letterSpacing: 3),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.isPasswordVisible =
                                        !controller.isPasswordVisible;
                                  },
                                  icon: !controller.isPasswordVisible
                                      ? SvgPicture.asset(
                                          "assets/images/preview-close.svg")
                                      : const Icon(
                                          Icons.visibility_off_outlined,
                                          color: AppColors.background)),
                            )),
                        const Gap(8),

                        // forget password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.offNamed(Routes.RESET_PASSWORD);
                                },
                                child: TextSemiBold("Forget Password?")),
                          ],
                        ),
                        const Gap(40),

                        // login button
                        TouchableOpacity(
                          disabled: !controller.isFormValid,
                          onTap: () {
                            if (controller.formKey.currentState == null) return;
                            if (controller.formKey.currentState!.validate()) {
                              final username = controller.isEmail
                                  ? controller.emailController.text.trim()
                                  : "${controller.countryController.text.trim()}${controller.phoneNumberController.text.trim()}";

                              controller.login(
                                context,
                                username,
                                controller.passwordController.text.trim(),
                              );
                            }
                          },
                          child: Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: !controller.isFormValid
                                    ? AppColors.primaryGrey
                                    : AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: AppColors.white.withOpacity(0.3),
                                ),
                                const Gap(5),
                                TextSemiBold(
                                  "Proceed Securely",
                                  color: AppColors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),

                        Center(
                            child: TextSemiBold(
                          "Or",
                          textAlign: TextAlign.center,
                        )),
                        const Gap(20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAsset.facebook, width: 50),
                            const Gap(10),
                            Image.asset(AppAsset.google, width: 50),
                          ],
                        ),
                        const Expanded(child: SetFingerPrint())
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
