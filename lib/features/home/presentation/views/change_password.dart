import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValid = false;
  
  void validateInput() {
    if (_formKey.currentState == null) return;
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      setState(() {
        _isValid = true;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _isValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "Change password",
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const Gap(20),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSemiBold("New password"),
                    const Gap(8),
                    TextFormField(
                      controller: newPasswordController,
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
                  ],
                )),
            const Gap(150),
            BusyButton(
              title: 'Confirm ',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  
                }
              },
              width: 247,
            )
          ],
        ),
      )),
    );
  }
}
