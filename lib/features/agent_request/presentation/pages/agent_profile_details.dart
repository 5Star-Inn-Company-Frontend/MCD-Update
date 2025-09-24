
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/textField.dart';

import '../../../../app/styles/app_colors.dart';
import '../../../../app/widgets/app_bar-two.dart';

class AgentProfileInfoScreen extends StatefulWidget {
  const AgentProfileInfoScreen({super.key});

  @override
  State<AgentProfileInfoScreen> createState() => _AgentProfileInfoScreenState();
}

class _AgentProfileInfoScreenState extends State<AgentProfileInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  bool _isLoading = false;
  bool _isFormValid = false;
  @override
  void dispose() {
    _firstNameController.dispose();
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "Personal Information",
        // elevation: 2,
      ),
      body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(15),
                  TextSemiBold("First Name"),
                  Gap(5),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: textInputDecoration.copyWith(
                      fillColor:AppColors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryGrey)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2, width: 0.2)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2)
                      ),
                    ),
                  ),
                  Gap(20),
                  TextSemiBold("Business Name"),
                  Gap(5),
                  TextFormField(
                    controller: _businessNameController,
                    decoration: textInputDecoration.copyWith(
                      fillColor:AppColors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2, width: 0.2)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2)
                      ),
                    ),
                  ),
                  Gap(20),
                  TextSemiBold("Date of birth /DD/MM/YY"),
                  Gap(5),
                  TextFormField(
                    controller: _dobController,
                    decoration: textInputDecoration.copyWith(
                      fillColor:AppColors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2, width: 0.2)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2)
                      ),
                    ),
                  ),
                  Gap(20),
                  TextSemiBold("Phone Number"),
                  Gap(5),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD9D9D9)),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      hintText: "",
                      onInputValidated: (bool value) {
                        print(value);
                      },

                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                        showFlags: false,
                        setSelectorButtonAsPrefixIcon: false
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: AppColors.textPrimaryColor),
                      initialValue: number,
                      textFieldController: _phoneController,
                      formatInput: true,
                      keyboardType:
                      TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(borderSide: BorderSide.none),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                  Gap(20),
                  TextSemiBold("Address"),
                  Gap(5),
                  TextFormField(
                    controller: _addressController,
                    decoration: textInputDecoration.copyWith(
                      fillColor:AppColors.white,
                      labelText: 'N0 / Street Address / State / Country',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2, width: 0.2)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textPrimaryColor2)
                      ),
                    ),
                  ),
                  Gap(30),
                  TouchableOpacity(
                    disabled: _isFormValid,
                    onTap: (){
                    },
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color:_isFormValid == false ? Color(0xff5ABB7B).withOpacity(0.18) : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: _isLoading ? const Center(child: CircularProgressIndicator(color: AppColors.white,)) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextSemiBold("Submit", color: AppColors.white,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
