import 'package:mcd/core/import/imports.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class LoginScreenPage extends GetView<LoginScreenController> {
  const LoginScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: BackButton(
          color: AppColors.primaryColor,
          onPressed: () {
            Get.offNamed(Routes.CREATEACCOUNT);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Form(
                    key: controller.formKey, // <- static FormKey
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemiBold("Login",
                            fontSize: 20, fontWeight: FontWeight.w500),
                        const Gap(15),

                        // Email toggle
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.isEmail = true;
                              },
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: AppColors.primaryColor, width: 1.5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                        fontFamily: AppFonts.manRope,
                                        fontSize: 14,
                                        color: const Color(0xFF1D1D1D),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(25),

                        // Email field (only reactive if necessary)
                        TextFormField(
                          controller: controller.emailController,
                          validator: (value) {
                            if (value == null && controller.isEmail) {
                              return "Input Email";
                            }
                            // if (controller.isEmail &&
                            //     !CustomValidator.validEmail(value!.trim())) {
                            //   return "Invalid Email";
                            // }
                            return null;
                          },
                          onChanged: (_) => controller.setFormValidState(),
                          decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintText: "name@mail.com",
                            hintStyle: const TextStyle(
                                color: AppColors.primaryGrey2),
                          ),
                        ),
                        const Gap(25),

                        // Password field
                        Obx(() => TextFormField(
                              controller: controller.passwordController,
                              obscureText: controller.isPasswordVisible.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Input password";
                                }
                                if (value.length < 6) {
                                  return "Password must contain 6 characters";
                                }
                                return null;
                              },
                              onChanged: (_) => controller.setFormValidState(),
                              obscuringCharacter: '*',
                              decoration: textInputDecoration.copyWith(
                                hintText: "**************",
                                hintStyle: const TextStyle(
                                  color: AppColors.primaryGrey2,
                                  fontSize: 20,
                                  letterSpacing: 3,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                  },
                                  icon: controller.isPasswordVisible.value
                                      ? const Icon(Icons.visibility_off_outlined,
                                          color: AppColors.background)
                                      : SvgPicture.asset(
                                          "assets/images/preview-close.svg"),
                                ),
                              ),
                            )),
                        const Gap(8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.RESET_PASSWORD);
                                },
                                child: TextSemiBold("Forget Password?")),
                          ],
                        ),
                        const Gap(40),

                        // Login button
                        Obx(() => TouchableOpacity(
                              disabled: !controller.isFormValid,
                              onTap: () {
                                if (!controller.formKey.currentState!
                                    .validate()) {
                                  return;
                                }

                                final username = controller.isEmail
                                    ? controller.emailController.text.trim()
                                    : "${controller.countryController.text.trim()}${controller.phoneNumberController.text.trim()}";

                                controller.login(
                                  context,
                                  username,
                                  controller.passwordController.text.trim(),
                                );
                              },
                              child: Container(
                                height: 55,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: controller.isFormValid
                                      ? AppColors.primaryColor
                                      : AppColors.primaryGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.lock,
                                        color: AppColors.white.withOpacity(0.3)),
                                    const Gap(5),
                                    TextSemiBold("Proceed Securely",
                                        color: AppColors.white),
                                  ],
                                ),
                              ),
                            )),
                        const Gap(20),

                        Center(child: TextSemiBold("Or")),
                        const Gap(20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAsset.facebook, width: 50),
                            const Gap(10),
                            Image.asset(AppAsset.google, width: 50),
                          ],
                        ),
                        // const Expanded(child: SetFingerPrint()),

                        const Gap(30),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextSemiBold(
                                "Don't have an account? "
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offNamed(Routes.CREATEACCOUNT);
                                },
                                child: TextSemiBold(
                                  "Sign up now",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Gap(30),
                        
                        Obx(() => controller.canCheckBiometrics
                          ? InkWell(
                              onTap: () async {
                                await controller.biometricLogin(context);
                              },
                              child: Center(
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 60),
                                    child: Image.asset(AppAsset.faceId, width: 50,)),
                              ),
                            )
                          : const SizedBox.shrink()
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
