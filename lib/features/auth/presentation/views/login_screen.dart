// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gap/gap.dart';
// // import 'package:go_router/go_router.dart';
// import 'package:mcd/app/styles/app_colors.dart';
// import 'package:mcd/app/styles/fonts.dart';
// // import 'package:mcd/app/widgets/app_bar-two.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// // import 'package:mcd/app/widgets/busy_button.dart';
// import 'package:mcd/app/widgets/loading_dialog.dart';
// import 'package:mcd/app/widgets/touchableOpacity.dart';
// import 'package:mcd/core/constants/app_asset.dart';
// import 'package:mcd/core/constants/fonts.dart';
// import 'package:mcd/core/constants/textField.dart';
// import 'package:mcd/core/utils/validator.dart';
// import 'package:mcd/features/auth/presentation/views/biometrrics.dart';
// import 'package:mcd/features/auth/presentation/views/reset_password_screen.dart';
// import 'package:mcd/features/home/presentation/views/home_navigation.dart';

// class LoginScreen extends StatefulWidget {
//   final Function? toggleView;
//   const LoginScreen({super.key, this.toggleView});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   // final TextEditingController emailController = TextEditingController();
//   // final TextEditingController passwordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   // bool _isValid = true;

//   bool _isEmail = true;
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();

//   final PhoneNumber _number = PhoneNumber(isoCode: 'NG');

//   bool _isPasswordVisible = true;
//   bool _isFormValid = false;

//   final bool _isLoading = false;

//   void setLoader(){
//     setState(() {
//       showLoadingDialog(context: context);
//     });
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         if(mounted){
//          Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const HomeNavigation()),
//               (Route<dynamic> route) => true);
//         }

//       });
//     });
//   }

//   String? _errorText;

//   void _validateInput(String value) {
//     if (CustomValidator.isValidAccountNumber(value.trim()) == false) {
//       setState(() {
//         _errorText = 'Please enter a valid phone';
//       });
//     } else {
//       setState(() {
//         _errorText = null;
//       });
//     }
//   }
//   void _setFormValidState(){
//     setState(() {
//        if (_formKey.currentState == null)return;
//         if (_formKey.currentState!.validate()) {
//           if (_isEmail == false) {
//             if (_phoneNumberController.text.isNotEmpty) {
//               _isFormValid = false;
//             }else{
//               _isFormValid = true;
//               _validateInput(_phoneNumberController.text.trim());
//             }
            
//           }else{
//             _isFormValid = false;
//           }
//         }else{
//           _isFormValid = true;
//         }
//     });
//   }

//   @override
//   void initState() {
//     _countryController.text = "+234";
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         leading: BackButton(color: AppColors.primaryColor, onPressed: (){
//         if(widget.toggleView == null)return;
//         widget.toggleView!(true);
//       },),
//       ),
//       body: AbsorbPointer(
//         absorbing: _isLoading,
//         child: LayoutBuilder(builder: (context, constraints) {
//           return SingleChildScrollView(
//             // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                   minWidth: constraints.maxWidth,
//                   minHeight: constraints.maxHeight),
//               child: IntrinsicHeight(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextSemiBold("Login or Create an account", fontSize: 20, fontWeight: FontWeight.w500,),
//                         const Gap(15),
//                         Row(
//                           children:[
//                             GestureDetector(
//                               onTap: () {
//                                 if (!mounted) return;
//                                 setState(() => _isEmail = false);
//                                 print(_isEmail);
//                               },
//                               child: AnimatedContainer(
//                                 decoration: BoxDecoration(
//                                     color: !_isEmail ? AppColors.primaryColor : AppColors.white,
//                                     borderRadius: BorderRadius.circular(7),
//                                     border: Border.all(color: !_isEmail ? Colors.white : AppColors.background, width: !_isEmail ? 1 : 0.0)
//                                   // borderRadius: const BorderRadius.only(
//                                   //     topLeft: Radius.circular(4),
//                                   //     bottomLeft: Radius.circular(4)),
//                                 ),
//                                 duration: const Duration(seconds: 1),
//                                 curve: Curves.fastOutSlowIn,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                                   child: Center(
//                                     child: Text(
//                                       'Phone',
//                                       style: TextStyle(
//                                           fontFamily: 'Merriweather',
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: 14,
//                                           color: !_isEmail
//                                               ? const Color(0xFFFFFFFF)
//                                               : const Color(0xFF1D1D1D)),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const Gap(15),
//                             GestureDetector(
//                               onTap: () {
//                                 if (!mounted) return;
//                                 setState(() => _isEmail = true);
//                                 print(_isEmail);
//                               },
//                               child: AnimatedContainer(
//                                 width: 80,
//                                 // width: SizeConfig.screenWidth,
//                                 //height: 195,//_selectedSub == 'basic' ? 195 : 146,
//                                 decoration: BoxDecoration(
//                                     color: _isEmail ? AppColors.primaryColor : AppColors.white,
//                                     borderRadius: BorderRadius.circular(7),
//                                     border: Border.all(color: _isEmail ? Colors.white : AppColors.background, width: _isEmail ? 1.5 : 0.0)
//                                 ),
//                                 duration: const Duration(seconds: 1),
//                                 curve: Curves.fastOutSlowIn,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Center(
//                                     child: Text(
//                                       'Email',
//                                       style: TextStyle(
//                                           fontFamily: AppFonts.manRope,
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: 14,
//                                           color: _isEmail
//                                               ? const Color(0xFFFFFFFF)
//                                               : const Color(0xFF1D1D1D)),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                           ],
//                         ),
//                         const Gap(25),
//                         _isEmail ?
//                         TextFormField(
//                           controller: _emailController,
//                           validator: (value){
//                             if(value == null && _isEmail == true)return "Input Email";
//                             if(CustomValidator.validEmail(value!.trim()) == false && _isEmail == true)return "Invalid Email";
//                             return null;
//                           },
//                           onChanged: (value){
//                             _setFormValidState();
//                           },
//                           textInputAction: TextInputAction.next,
//                           decoration: textInputDecoration.copyWith(
//                               filled: false,
//                               hintText: "name@mail.com",
//                               hintStyle: const TextStyle(
//                                   color: AppColors..primaryGrey2//                               )
//                           ),
//                         ) :
//                         Column(
//                           children: [
//                             _errorText == null ? Container(): TextSemiBold(_errorText.toString(), color: Colors.red, fontSize: 12,),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: TextFormField(
//                                     controller: _countryController,
//                                     enabled: false,
//                                     decoration: textInputDecoration.copyWith(
//                                         filled: false,
                            
//                                     ),
                                      
//                                   ),
//                                 ),
//                                 const Gap(15),
                                
//                                 Expanded(
//                                   flex: 3,
//                                   child: TextFormField(
//                                     controller: _phoneNumberController,
//                                     onChanged: (value){
//                                       _validateInput(value);
//                                       _setFormValidState();
//                                     },
//                                keyboardType: TextInputType.number,
//                           textInputAction: TextInputAction.next,
//                                     decoration: textInputDecoration.copyWith(
//                                         filled: false
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const Gap(25),

//                         TextFormField(
                        
//                           controller: _passwordController,
//                           obscureText: _isPasswordVisible,
//                           validator: (value){
//                             if(value == null)return "Input password";
//                             if(value.length < 6)return "Password must contain 6 characters ";
//                             return null;
//                           },
//                           onChanged: (value){
//                            _setFormValidState();
//                            _validateInput(_phoneNumberController.text.trim());
//                           },
//                           obscuringCharacter: '*',
//                           decoration: textInputDecoration.copyWith(
//                             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//                               fillColor: AppColors.white,
//                               hintText: "**************",
//                               hintStyle: const TextStyle(
//                                   color: AppColors..primaryGrey2
//                                   fontSize: 20,
//                                   letterSpacing: 3
//                               ),
//                             suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _isPasswordVisible = !_isPasswordVisible;
//                                   });
//                                 },
//                                 icon: !_isPasswordVisible ? SvgPicture.asset("assets/images/preview-close.svg") : const Icon(
//                                   Icons.visibility_off_outlined,
//                                   color: AppColors.background
//                                 )
//                             ),
//                           )
//                         ),
//                         const Gap(8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             GestureDetector(
//                               onTap: (){
//                                 Navigator.of(context).push(
//                                     MaterialPageRoute(builder: (context) => const ResetPasswordScreen()));
//                               },
//                                 child: TextSemiBold("Forget Password?")),
//                           ],
//                         ),
//                         const Gap(40),
//                         TouchableOpacity(
//                           disabled: _isFormValid,
//                           onTap: (){
//                             if(_formKey.currentState == null)return;
//                             if(_formKey.currentState!.validate()){
//                               if(_isEmail == false && _passwordController.text.trim().isEmpty){
//                                 _validateInput(_passwordController.text.trim());
//                               }else{
//                                 setLoader();
                               
//                               }
//                               // context.go();
//                               // showLoadingDialog(context: context);
                              
//                             }
//                           },
//                           child: Container(
//                             height: 55,
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             decoration: BoxDecoration(
//                                 color: _isFormValid ? AppColors.primaryGrey : AppColors.primaryColor,
//                                 borderRadius: BorderRadius.circular(8)
//                             ),
//                             child: _isLoading ? const Center(child: CircularProgressIndicator(color: AppColors.white,)) : Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.lock,color: AppColors.white.withOpacity(0.3),),
//                                 const Gap(5),
//                                 TextSemiBold("Proceed Securely", color: AppColors.white,)
//                               ],
//                             ),
//                           ),
//                         ),
//                         const Gap(20),
//                         Center(child: TextSemiBold("Or", textAlign: TextAlign.center,)),
//                         const Gap(20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(AppAsset.facebook, width: 50,),
//                             const Gap(10),
//                             Image.asset(AppAsset.google, width: 50,)
//                           ],
//                         ),
//                         // Spacer(),
//                          const Expanded(
//                           child: SetFingerPrint()
//                         )

//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       )

//     );
//   }

//   Widget buttomOption(String title, bool _isEmail){
//     return Container(
//       width: 80,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//       decoration: BoxDecoration(
//         color: _isEmail ? AppColors.white : AppColors.primaryColor,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: _isEmail ? AppColors.inputFieldBorder : AppColors.white, width: _isEmail ? 0.1 : 1)
//       ),
//       child: TextSemiBold("Phone", textAlign: TextAlign.center, color: _isEmail ? AppColors.background : AppColors.white,),
//     );
//   }
// }






 


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:mcd/app/widgets/loading_dialog.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/validator.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mcd/features/auth/presentation/views/biometrrics.dart';
import 'package:mcd/features/auth/presentation/views/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function? toggleView;
  const LoginScreen({super.key, this.toggleView});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isEmail = true;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final PhoneNumber number = PhoneNumber(isoCode: 'NG');

  bool _isPasswordVisible = true;
  bool _isFormValid = false;

  String? _errorText;

  void _validateInput(String value) {
    if (CustomValidator.isValidAccountNumber(value.trim()) == false) {
      setState(() {
        _errorText = 'Please enter a valid phone';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _setFormValidState() {
    setState(() {
      if (_formKey.currentState == null) return;
      if (_formKey.currentState!.validate()) {
        if (_isEmail == false) {
          if (_phoneNumberController.text.isNotEmpty) {
            _isFormValid = true;
          } else {
            _isFormValid = false;
            _validateInput(_phoneNumberController.text.trim());
          }
        } else {
          _isFormValid = true;
        }
      } else {
        _isFormValid = false;
      }
    });
  }

  @override
  void initState() {
    _countryController.text = "+234";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: BackButton(
          color: AppColors.primaryColor,
          onPressed: () {
            if (widget.toggleView == null) return;
            widget.toggleView!(true);
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
                  key: _formKey,
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
                              if (!mounted) return;
                              setState(() => _isEmail = false);
                            },
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                  color: !_isEmail
                                      ? AppColors.primaryColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: !_isEmail
                                          ? Colors.white
                                          : AppColors.background,
                                      width: !_isEmail ? 1 : 0.0)),
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
                                        color: !_isEmail
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
                              if (!mounted) return;
                              setState(() => _isEmail = true);
                            },
                            child: AnimatedContainer(
                              width: 80,
                              decoration: BoxDecoration(
                                  color: _isEmail
                                      ? AppColors.primaryColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: _isEmail
                                          ? Colors.white
                                          : AppColors.background,
                                      width: _isEmail ? 1.5 : 0.0)),
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
                                        color: _isEmail
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
                      _isEmail
                          ? TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null && _isEmail == true) {
                                  return "Input Email";
                                }
                                if (CustomValidator.validEmail(value!.trim()) ==
                                        false &&
                                    _isEmail == true) {
                                  return "Invalid Email";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _setFormValidState();
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
                                _errorText == null
                                    ? Container()
                                    : TextSemiBold(
                                        _errorText.toString(),
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _countryController,
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
                                        controller: _phoneNumberController,
                                        onChanged: (value) {
                                          _validateInput(value);
                                          _setFormValidState();
                                        },
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        decoration:
                                            textInputDecoration.copyWith(
                                                filled: false),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const Gap(25),

                      // password widget
                      TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordVisible,
                          validator: (value) {
                            if (value == null) return "Input password";
                            if (value.length < 6) {
                              return "Password must contain 6 characters";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _setFormValidState();
                            _validateInput(_phoneNumberController.text.trim());
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
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: !_isPasswordVisible
                                    ? SvgPicture.asset(
                                        "assets/images/preview-close.svg")
                                    : const Icon(Icons.visibility_off_outlined,
                                        color: AppColors.background)),
                          )),
                      const Gap(8),

                      // forget password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordScreen()));
                              },
                              child: TextSemiBold("Forget Password?")),
                        ],
                      ),
                      const Gap(40),

                      // login button
                      TouchableOpacity(
                        disabled: !_isFormValid,
                        onTap: () {
                          if (_formKey.currentState == null) return;
                          if (_formKey.currentState!.validate()) {
                            final username = _isEmail
                            ? _emailController.text.trim()
                            : "${_countryController.text.trim()}${_phoneNumberController.text.trim()}";

                            controller.login(
                              context,
                              username,
                              _passwordController.text.trim(),
                            );

                          }
                        },
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: !_isFormValid
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
  }
}
