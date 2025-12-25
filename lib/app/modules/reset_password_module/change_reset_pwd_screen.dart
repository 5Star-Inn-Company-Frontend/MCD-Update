import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;
/// GetX Template Generator - fb.com/htngu.99
///

class ChangeResetPwdPage extends GetView<ResetPasswordController> {
  const ChangeResetPwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get email and code from arguments safely
    final args = Get.arguments as Map<String, dynamic>?;
    final email = args?['email'] ?? controller.emailController.text;
    final code = args?['code'] ?? controller.codeController.text;
    
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: "Change Password", centerTitle: false,),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: controller.formKey3,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TextSemiBold("New Password", fontSize: 20, fontWeight: FontWeight.w500,),

                      TextSemiBold("New password"),
                      const Gap(8),
                      
                      TextFormField(
                        controller: controller.newPasswordController,
                        obscureText: true,
                        validator: (value) => CustomValidator.validateStrongPassword(value),
                        onChanged: (value) {
                          controller.validateInput();
                        },
                        style: const TextStyle(
                            fontFamily: AppFonts.manRope
                        ),
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintText: "Enter new password",
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope)),
                      ),
                      const Gap(12),
                      
                      /// Password Strength Indicator
                      Obx(() {
                        if (!controller.hasPasswordText) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextSemiBold(
                                  "Password Strength: ",
                                  fontSize: 12,
                                  color: AppColors.primaryGrey2,
                                ),
                                TextSemiBold(
                                  controller.passwordStrengthLabel,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getStrengthColor(controller.passwordStrength),
                                ),
                              ],
                            ),
                            const Gap(8),
                            // Strength bar
                            Row(
                              children: List.generate(4, (index) {
                                return Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                                    decoration: BoxDecoration(
                                      color: index < controller.passwordStrength
                                          ? _getStrengthColor(controller.passwordStrength)
                                          : AppColors.primaryGrey2.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const Gap(12),
                            
                            /// Password Requirements Checklist
                            _buildRequirement(
                              "At least 8 characters",
                              controller.hasMinLength,
                            ),
                            const Gap(6),
                            _buildRequirement(
                              "Starts with uppercase letter",
                              controller.startsWithUppercase,
                            ),
                            const Gap(6),
                            _buildRequirement(
                              "Contains uppercase letter (A-Z)",
                              controller.hasUppercase,
                            ),
                            const Gap(6),
                            _buildRequirement(
                              "Contains lowercase letter (a-z)",
                              controller.hasLowercase,
                            ),
                            const Gap(6),
                            _buildRequirement(
                              "Contains number (0-9)",
                              controller.hasNumber,
                            ),
                            const Gap(6),
                            _buildRequirement(
                              "Contains special character (!@#\$%^&*)",
                              controller.hasSpecialChar,
                            ),
                            const Gap(20),
                          ],
                        );
                      }),
                      
                      const Gap(10),
                      
                      TextSemiBold("Confirm password"),
                      const Gap(8),
                      TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm password is required";
                          }
                          if (value != controller.newPasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.validateInput();
                        },
                        style: const TextStyle(
                            fontFamily: AppFonts.manRope
                        ),
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintText: "Re-enter new password",
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope)),
                      ),

                       const Gap(150),
                       /// Submit
                      Obx(() => GestureDetector(
                        onTap: () async {
                          if (controller.formKey3.currentState == null) return;
                          if (controller.formKey3.currentState!.validate()) {
                            if (controller.newPasswordController.text != controller.confirmPasswordController.text) {
                              Get.snackbar("Error", "Passwords do not match", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
                              return;
                            }
                            dev.log("Submitting password change...");
                            final emailToUse = email.isNotEmpty ? email : controller.emailController.text.trim();
                            final codeToUse = code.isNotEmpty ? code : controller.codeController.text.trim();
                            controller.changeResetPassword(
                              context, 
                              emailToUse, 
                              codeToUse, 
                              controller.newPasswordController.text
                            );
                          }
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: controller.isValid.value 
                              ? AppColors.primaryColor 
                              : AppColors.primaryGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, color: AppColors.white.withOpacity(0.3)),
                              const Gap(5),
                              TextSemiBold("Proceed Securely", color: AppColors.white,)
                            ],
                          ),
                        ),
                      )),
                    ]
                  )
                )
              )
            )
          )
        );
      })
    );
  }

  /// Helper method to build password requirement item
  Widget _buildRequirement(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.cancel,
          color: isMet ? Colors.green : AppColors.primaryGrey2,
          size: 16,
        ),
        const Gap(8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : AppColors.primaryGrey2,
              fontFamily: 'Manrope',
            ),
          ),
        ),
      ],
    );
  }

  /// Helper method to get color based on password strength
  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow[700]!;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}