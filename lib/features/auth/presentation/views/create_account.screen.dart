import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/validator.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mcd/routes/app_routes.dart';
// import 'package:mcd/features/auth/presentation/views/verify_otp_screen.dart';

class CreateAccount extends StatefulWidget {
  final Function? toggleView;
  const CreateAccount({super.key, this.toggleView});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  void _validateForm() {
    if (_formKey.currentState == null) return;
    setState(() {
      _isFormValid = _formKey.currentState!.validate();
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
            widget.toggleView!(false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold(
                  "Create an account",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                const Gap(15),

                /// Username
                TextSemiBold("Username"),
                const Gap(8),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) =>
                      CustomValidator.isEmptyString(value!, "username"),
                  onChanged: (_) => _validateForm(),
                  decoration: textInputDecoration.copyWith(
                    hintText: "samji222",
                    hintStyle: const TextStyle(color: AppColors.primaryGrey2),
                  ),
                ),
                const Gap(25),

                /// Email
                TextSemiBold("Email address"),
                const Gap(8),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    CustomValidator.isEmptyString(value!, "email");
                    if (!CustomValidator.validEmail(value)) {
                      return "Invalid Email";
                    }
                    return null;
                  },
                  onChanged: (_) => _validateForm(),
                  decoration: textInputDecoration.copyWith(
                    hintText: "name@mail.com",
                    hintStyle: const TextStyle(color: AppColors.primaryGrey2),
                  ),
                ),
                const Gap(25),

                /// Phone
                TextSemiBold("Phone number"),
                const Gap(8),
                Row(
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
                        validator: (value) =>
                            CustomValidator.isEmptyString(value!, "phone"),
                        onChanged: (_) => _validateForm(),
                        keyboardType: TextInputType.phone,
                        decoration: textInputDecoration.copyWith(
                          hintText: "08012345678",
                          hintStyle:
                              const TextStyle(color: AppColors.primaryGrey2),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(25),

                /// Password
                TextSemiBold("Password"),
                const Gap(8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  obscuringCharacter: '*',
                  validator: (value) {
                    CustomValidator.isEmptyString(value!, "password");
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  onChanged: (_) => _validateForm(),
                  decoration: textInputDecoration.copyWith(
                    hintText: "**************",
                    hintStyle: const TextStyle(
                      color: AppColors.primaryGrey2,
                      fontSize: 20,
                      letterSpacing: 3,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: _isPasswordVisible
                          ? const Icon(Icons.visibility_off_outlined,
                              color: AppColors.background)
                          : SvgPicture.asset("assets/images/preview-close.svg"),
                    ),
                  ),
                ),
                const Gap(40),

                /// Submit
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState == null) return;
                    if (_formKey.currentState!.validate()) {
                      final userData = UserSignupData(
                        username: _usernameController.text.trim(),
                        email: _emailController.text.trim(),
                        phone: _phoneNumberController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      controller.pendingSignupData = userData; // Store the user data
                      await controller.sendCode(context, _emailController.text.trim());
                    }
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isFormValid ? AppColors.primaryColor : AppColors.primaryGrey,
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
                const Gap(20),

                /// Social
                Center(child: TextSemiBold("Or", textAlign: TextAlign.center,)),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppAsset.facebook, width: 50),
                    const Gap(10),
                    Image.asset(AppAsset.google, width: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}