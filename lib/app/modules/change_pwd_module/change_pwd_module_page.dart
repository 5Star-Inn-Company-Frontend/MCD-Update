import 'package:mcd/core/import/imports.dart';
import './change_pwd_module_controller.dart';

class ChangePwdModulePage extends GetView<ChangePwdModuleController> {
    
    const ChangePwdModulePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
                backgroundColor: AppColors.white,
                elevation: 0,
                leading: BackButton(
                    color: AppColors.primaryColor,
                ),
                title: TextSemiBold(
                    'Change password',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                ),
                centerTitle: false,
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Form(
                        key: controller.formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Gap(20),
                                
                                // Old Password
                                TextSemiBold('Old password'),
                                const Gap(8),
                                Obx(() => TextFormField(
                                    controller: controller.oldPasswordController,
                                    obscureText: controller.isOldPasswordVisible.value,
                                    obscuringCharacter: '*',
                                    validator: (value) =>
                                        CustomValidator.isEmptyString(value!, "old password"),
                                        style: TextStyle(fontFamily: AppFonts.manRope,),
                                    decoration: textInputDecoration.copyWith(
                                      hintText: "Enter old password",
                                      hintStyle: const TextStyle(color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope),
                                      filled: true,
                                      fillColor: AppColors.white,
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
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                              controller.isOldPasswordVisible.value =
                                                  !controller.isOldPasswordVisible.value;
                                          },
                                          icon: Icon(
                                              controller.isOldPasswordVisible.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: AppColors.primaryGrey2,
                                          ),
                                      ),
                                    ),
                                )),
                                const Gap(25),
                                
                                // New Password
                                TextSemiBold('New password'),
                                const Gap(8),
                                Obx(() => TextFormField(
                                    controller: controller.newPasswordController,
                                    obscureText: controller.isNewPasswordVisible.value,
                                    obscuringCharacter: '*',
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                            return "Please enter new password";
                                        }
                                        if (value.length < 6) {
                                            return "Password must be at least 6 characters";
                                        }
                                        return null;
                                    },
                                    style: TextStyle(fontFamily: AppFonts.manRope,),
                                    decoration: textInputDecoration.copyWith(
                                        hintText: "Enter new password",
                                        hintStyle: const TextStyle(color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope),
                                        filled: true,
                                        fillColor: AppColors.white,
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
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                                controller.isNewPasswordVisible.value =
                                                    !controller.isNewPasswordVisible.value;
                                            },
                                            icon: Icon(
                                                controller.isNewPasswordVisible.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.primaryGrey2,
                                            ),
                                        ),
                                    ),
                                )),
                                const Gap(25),
                                
                                // Confirm Password
                                TextSemiBold('Confirm password'),
                                const Gap(8),
                                Obx(() => TextFormField(
                                    controller: controller.confirmPasswordController,
                                    obscureText: controller.isConfirmPasswordVisible.value,
                                    obscuringCharacter: '*',
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                            return "Please confirm your password";
                                        }
                                        if (value != controller.newPasswordController.text) {
                                            return "Passwords do not match";
                                        }
                                        return null;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText: "Confirm new password",
                                        hintStyle: const TextStyle(color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope),
                                        filled: true,
                                        fillColor: AppColors.white,
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
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                                controller.isConfirmPasswordVisible.value =
                                                    !controller.isConfirmPasswordVisible.value;
                                            },
                                            icon: Icon(
                                                controller.isConfirmPasswordVisible.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.primaryGrey2,
                                            ),
                                        ),
                                    ),
                                )),
                                const Gap(120),
                                
                                // Submit Button
                                Obx(() => GestureDetector(
                                    onTap: controller.isLoading.value
                                        ? null
                                        : () => controller.changePassword(),
                                    child: Container(
                                        height: 55,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: controller.isLoading.value
                                                ? AppColors.primaryColor.withOpacity(0.6)
                                                : AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                            child: controller.isLoading.value
                                                ? const SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: CircularProgressIndicator(
                                                        color: AppColors.white,
                                                        strokeWidth: 2,
                                                    ),
                                                )
                                                : TextSemiBold(
                                                    "Confirm",
                                                    color: AppColors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                ),
                                        ),
                                    ),
                                )),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}