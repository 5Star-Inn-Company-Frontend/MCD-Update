import 'package:mcd/core/import/imports.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ResetPasswordPage extends GetView<ResetPasswordController> {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(title: ""),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Form(
                    key: controller.formKey1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemiBold("Reset Password", fontSize: 20, fontWeight: FontWeight.w500,),

                        const Gap(15),
                        Row(
                          children:[
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  color: controller.isEmail.value ? AppColors.primaryColor : AppColors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: controller.isEmail.value ? Colors.white : AppColors.primaryGrey2, width: controller.isEmail.value ? 1.5 : 0.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                        fontFamily: 'Merriweather',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: controller.isEmail.value
                                            ? const Color(0xFFFFFFFF)
                                            : const Color(0xFF1D1D1D)),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),

                        const Gap(25),
                        AnimatedContainer(
                          duration: const Duration(seconds: 3),
                          curve: Curves.fastOutSlowIn,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextSemiBold("Email address"),
                              const Gap(8),
                              TextFormField(
                                controller: controller.emailController,
                                validator: (value){
                                  if( controller.isEmail.value == true && value == null)return "Input email";
                                  if(controller.isEmail.value == true && CustomValidator.validEmail(value!) == false){
                                    return "Invalid email";
                                  }
                                  return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                    filled: false,
                                    hintText: "name@mail.com",
                                    hintStyle: const TextStyle(
                                        color: AppColors.primaryGrey2
                                    )
                                ),
                              ),
                              const Gap(20),
                              TextSemiBold("We use your Email to identify your account")
                            ],
                          ),
                        ),

                        const Gap(40),
                        const Spacer(),
                        BusyButton(
                          onTap: (){
                            if(controller.formKey1.currentState == null)return;
                            if(controller.formKey1.currentState!.validate()){
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(builder: (context) => VerifyResetOtpScreen(email: controller.emailController.text, phoneNumber: _phoneNumberController.text,)));
                              
                              controller.resetPassword(context, controller.emailController.text.trim());
                            }
                          },
                          title: "Send OTP",
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        })

    );
  }
}
