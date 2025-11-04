import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;
/// GetX Template Generator - fb.com/htngu.99
///

class ChangeResetPwdPage extends GetView<ResetPasswordController> {
  const ChangeResetPwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: ""),
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
                      TextSemiBold("New Password", fontSize: 20, fontWeight: FontWeight.w500,),

                      TextSemiBold("New password"),
                      const Gap(8),
                      
                      TextFormField(
                        controller: controller.newPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.validateInput();
                        },
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintText: "Enter new password",
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2)),
                      ),
                      
                      const Gap(30),
                      
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
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintText: "Re-enter new password",
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2)),
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
                            controller.changeResetPassword(
                              context, 
                              controller.emailController.text, 
                              controller.codeController.text, 
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
}