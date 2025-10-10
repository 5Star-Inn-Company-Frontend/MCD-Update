import 'package:mcd/core/import/imports.dart';

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
                        validator: (value) {
                          CustomValidator.isEmptyString(value!, "username");
                          return null;
                        },
                        onChanged: (value) {
                          controller.validateInput();
                        },
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2)),
                      ),
                      
                      const Gap(30),
                      
                      TextSemiBold("Confirm password"),
                      const Gap(8),
                      TextFormField(
                        controller: controller.confirmPasswordController,
                        validator: (value) {
                          CustomValidator.isEmptyString(value!, "username");
                          // if(CustomValidator.validEmail(value)){
                          //   return "Invalid Email";
                          // }
                          return null;
                        },
                        onChanged: (value) {
                          controller.validateInput();
                        },
                        decoration: textInputDecoration.copyWith(
                            filled: false,
                            hintStyle: const TextStyle(color: AppColors.primaryGrey2)),
                      ),

                       const Gap(150),
                       /// Submit
                      GestureDetector(
                        onTap: () async {
                          if (controller.formKey3.currentState == null) return;
                          if (controller.formKey3.currentState!.validate()) {
                            controller.changeResetPassword(context, controller.emailController.text, controller.codeController.text, controller.newPasswordController.text);
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