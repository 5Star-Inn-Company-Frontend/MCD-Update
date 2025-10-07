import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/validator.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';

class ChangeResetPasswordScreen extends StatefulWidget {
  const ChangeResetPasswordScreen({super.key});

  @override
  State<ChangeResetPasswordScreen> createState() => _ChangeResetPasswordScreenState();
}

class _ChangeResetPasswordScreenState extends State<ChangeResetPasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isValid = false;
  
  void validateInput() {
    if (_formKey.currentState == null) return;
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() {
        isValid = true;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isValid = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final email = Get.arguments['email'];
    final code = Get.arguments['code'];
    final password = Get.arguments['password'];
    
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
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSemiBold("New Password", fontSize: 20, fontWeight: FontWeight.w500,),

                      TextSemiBold("New password"),
                      const Gap(8),
                      TextFormField(
                        controller: newPasswordController,
                        validator: (value) {
                          CustomValidator.isEmptyString(value!, "username");
                          return null;
                        },
                        onChanged: (value) {
                          validateInput();
                        },
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2)),
                      ),
                      
                      const Gap(30),
                      
                      TextSemiBold("Confirm password"),
                      const Gap(8),
                      TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) {
                          CustomValidator.isEmptyString(value!, "username");
                          // if(CustomValidator.validEmail(value)){
                          //   return "Invalid Email";
                          // }
                          return null;
                        },
                        onChanged: (value) {
                          validateInput();
                        },
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2)),
                      ),

                       const Gap(150),
                       /// Submit
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState == null) return;
                          if (_formKey.currentState!.validate()) {
                            authController.changeResetPassword(context, email, code, password);
                          }
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
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
                      ),
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