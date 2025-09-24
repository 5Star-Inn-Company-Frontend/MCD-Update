import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/validator.dart';
import 'package:mcd/features/auth/presentation/views/reset_password_otp.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // bool _isValid = true;

  bool _isEmail = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  // PhoneNumber _number = PhoneNumber(isoCode: 'NG');

  bool _isPasswordVisible = false;

  @override
  void initState() {
    _countryController.text = "+234";
    super.initState();
  }

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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemiBold("Reset Password", fontSize: 20, fontWeight: FontWeight.w500,),

                        const Gap(15),
                        Row(
                          children:[
                            GestureDetector(
                              onTap: () {
                                if (!mounted) return;
                                setState(() => _isEmail = false);
                                print(_isEmail);
                              },
                              child: AnimatedContainer(
                                decoration: BoxDecoration(
                                    color: !_isEmail ? AppColors.primaryColor : AppColors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: !_isEmail ? Colors.white : AppColors.primaryGrey2, width: !_isEmail ? 1 : 0.0)
                                  // borderRadius: const BorderRadius.only(
                                  //     topLeft: Radius.circular(4),
                                  //     bottomLeft: Radius.circular(4)),
                                ),
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Center(
                                    child: Text(
                                      'Phone',
                                      style: TextStyle(
                                          fontFamily: 'Merriweather',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: !_isEmail
                                              ? const Color(0xFFFFFFFF)
                                              : const Color(0xFF1D1D1D)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(15),
                            GestureDetector(
                              onTap: () {
                                if (!mounted) return;
                                setState(() => _isEmail = true);
                                print(_isEmail);
                              },
                              child: AnimatedContainer(
                                width: 80,
                                // width: SizeConfig.screenWidth,
                                //height: 195,//_selectedSub == 'basic' ? 195 : 146,
                                decoration: BoxDecoration(
                                    color: _isEmail ? AppColors.primaryColor : AppColors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: _isEmail ? Colors.white : AppColors.primaryGrey2, width: _isEmail ? 1.5 : 0.0)
                                ),
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontFamily: 'Merriweather',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: _isEmail
                                              ? const Color(0xFFFFFFFF)
                                              : const Color(0xFF1D1D1D)),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        const Gap(25),
                        _isEmail ?
                        AnimatedContainer(
                          duration: const Duration(seconds: 3),
                          curve: Curves.fastOutSlowIn,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextSemiBold("Email address"),
                              const Gap(8),
                              TextFormField(
                                controller: _emailController,
                                validator: (value){
                                  if( _isEmail == true && value == null)return "Input email";
                                  if(_isEmail == true && CustomValidator.validEmail(value!) == false){
                                    return "Invalid email";
                                  }
                                },
                                decoration: textInputDecoration.copyWith(
                                    filled: false,
                                    hintText: "name@mail.com",
                                    hintStyle: const TextStyle(
                                        color: AppColors.background
                                    )
                                ),
                              ),
                              const Gap(20),
                              TextSemiBold("We use your Email to identify your account")
                            ],
                          ),
                        ) :
                        AnimatedContainer(
                          duration: const Duration(seconds: 3),
                          curve: Curves.fastOutSlowIn,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _countryController,
                                  enabled: false,
                                  decoration: textInputDecoration.copyWith(
                                    filled: false,

                                  ),
                                ),
                              ),
                              const Gap(15),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _phoneNumberController,
                                  validator: (value){
                                    if( _isEmail == false && value == null)return "Input email";
                                    if(_isEmail == false && CustomValidator.isValidAccountNumber(value!) == false){
                                      return "Invalid phone number";
                                    }
                                  },
                                  decoration: textInputDecoration.copyWith(
                                      filled: false
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(40),
                        const Spacer(),
                        BusyButton(
                          onTap: (){
                            if(_formKey.currentState == null)return;
                            if(_formKey.currentState!.validate()){
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => VerifyResetOtpScreen(email: _emailController.text, phoneNumber: _phoneNumberController.text,)));
                            }
                          },
                          title: "Send OTP",
                        )],
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
