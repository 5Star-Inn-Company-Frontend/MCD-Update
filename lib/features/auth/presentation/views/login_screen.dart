import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
// import 'package:mcd/features/auth/presentation/views/biometrrics.dart';
import 'package:mcd/features/auth/presentation/views/reset_password_screen.dart';
import 'dart:developer' as dev;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    super.initState();
    _countryController.text = "+234";

    GetStorage.init().then((_) {
      final box = GetStorage();
      final controller = Get.find<AuthController>();
      final biometricEnabled = box.read('biometric_enabled') ?? false;

      if (biometricEnabled) {
        Future.delayed(const Duration(milliseconds: 800), () {
          controller.biometricLogin(context);
        });
      }
    });
  }

  // @override
  // void initState() {
  //   _countryController.text = "+234";
  //   super.initState();
  // }

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
                          keyboardType: TextInputType.number,
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
                          // facebook login
                          InkWell(
                            onTap: () async {
                              try {
                                final LoginResult fbResult = await FacebookAuth.instance.login(
                                  permissions: ['email', 'public_profile'],
                                );

                                if (fbResult.status == LoginStatus.success) {
                                  final userData = await FacebookAuth.instance.getUserData();

                                  final email = userData['email'] ?? '';
                                  final name = userData['name'] ?? '';
                                  final avatar = userData['picture']['data']['url'] ?? '';
                                  final accessToken = fbResult.accessToken!.token;
                                  const source = 'facebook';

                                  await controller.socialLogin(
                                    context,
                                    email,
                                    name,
                                    avatar,
                                    accessToken,
                                    source,
                                  );
                                  dev.log('Facebook login successful');
                                } else if (fbResult.status == LoginStatus.cancelled) {
                                  Get.snackbar("Login Cancelled", "Facebook login was cancelled");
                                } else {
                                  Get.snackbar("Error", "Facebook login failed: ${fbResult.message}");
                                }
                              } catch (e) {
                                Get.snackbar("Error", "Facebook login error: $e");
                              }
                            },
                            child: SvgPicture.asset(AppAsset.facebook, width: 50),
                          ),
                          
                          const Gap(10),
                          
                          // google login
                          InkWell(
                            onTap: () async {
                              // try {
                              //   final GoogleSignIn _googleSignIn = GoogleSignIn(
                              //     scopes: ['email', 'profile'],
                              //   );

                              //   final GoogleSignInAccount? account = await _googleSignIn.signIn();
                              //   if (account == null) {
                              //     Get.snackbar("Cancelled", "Google login cancelled");
                              //     return;
                              //   }

                              //   final GoogleSignInAuthentication auth = await account.authentication;

                              //   final email = account.email;
                              //   final name = account.displayName ?? '';
                              //   final avatar = account.photoUrl ?? '';
                              //   final accessToken = auth.accessToken ?? '';
                              //   const source = 'google';

                              //   await controller.socialLogin(
                              //     context,
                              //     email,
                              //     name,
                              //     avatar,
                              //     accessToken,
                              //     source,
                              //   );

                              //   dev.log('Google login successful');
                              // } catch (e) {
                              //   Get.snackbar("Error", "Google login error: $e");
                              //   dev.log('Google login error: $e');
                              // }
                            },
                            child: Image.asset(AppAsset.google, width: 50),
                          ),
                        ],
                      ),
                      const Gap(50),

                      // // SetFingerPrint()
                      InkWell(
                        onTap: () async {
                          await controller.biometricLogin(context);
                        },
                        child: Center(
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 60),
                              child: Image.asset(AppAsset.faceId, width: 50,)),
                        ),
                      ),
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
