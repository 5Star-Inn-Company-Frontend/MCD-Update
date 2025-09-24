import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/logger.dart';

class Airtime2Cash extends StatefulWidget {
  const Airtime2Cash({super.key});

  @override
  State<Airtime2Cash> createState() => _Airtime2CashState();
}

class _Airtime2CashState extends State<Airtime2Cash> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _accountNo = TextEditingController();
  int _selectedValue = 1;
    String? selectedValue;
  final List<String> _dropdownItems = [ 'Choose Bank','First Bank', 'Zenith Bank', 'Coronation Bank'];
  @override
  void dispose() {
    _amount.dispose();
    _phone.dispose();
    _accountNo.dispose();
    super.dispose();
  }
   bool _isformValid = false;

  void setFormState() {
    setState(() {
      if(_formKey.currentState == null)return;
      if(_formKey.currentState!.validate()){
        logger.d("message");
        _isformValid = true;
      }else{
        _isformValid = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Airtime to cash",
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextSemiBold(
                      "Fill out the form below and transfer the airtime to the shown phone number (MTN Charges: 20% AIRTEL_Charges: 20%)"),
                  const Gap(20),
                  TextSemiBold("Select Network", color: AppColors.background),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.5),
                      border: Border.all(
                          color: const Color(0xffD9D9D9), width: 1.0),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/images/mtn.png",
                            width: 70,
                            height: 80,
                          ),
                          Image.asset("assets/images/airtel.png",
                              width: 70, height: 80),
                          Image.asset("assets/images/etisalat.png",
                              width: 70, height: 80),
                          Image.asset("assets/images/glo.png",
                              width: 70, height: 80)
                        ]),
                  ),
                  const Gap(20),
                  TextSemiBold("Enter amount to send",
                      color: AppColors.background),
                  const Gap(6),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        filled: true,
                        fillColor: const Color(0xffFFFFFF),
                        hintText: "e.g 0123456789",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffD9D9D9).withOpacity(0.5)))),
                  ),
                  const Gap(25),
                  TextSemiBold("Enter sender phone number",
                      color: AppColors.background),
                  const Gap(6),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        filled: true,
                        fillColor: const Color(0xffFFFFFF),
                        hintText: "100-50,000",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xffD9D9D9).withOpacity(0.5)))),
                  ),
                  const Gap(20),
                  TextSemiBold(
                    'Select where to receive payment',
                    fontSize: 13,
                  ),
                  const Gap(9),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffE0E0E0))),
                    child: Column(
                      children: [
                        RadioListTile(
                          title: const Text('MCD Wallet'),
                          contentPadding: EdgeInsets.zero,
                          value: 1,
                          activeColor: AppColors.primaryGreen,
                          controlAffinity: ListTileControlAffinity.trailing,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Bank'),
                          contentPadding: EdgeInsets.zero,
                          value: 2,
                          activeColor: AppColors.primaryGreen,
                          controlAffinity: ListTileControlAffinity.trailing,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                 Visibility(
                  visible: _selectedValue == 2,
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          const Gap(20),
                        TextSemiBold("Select Bank"),
                        const Gap(6),
                        DropdownButtonFormField<String>(
                          elevation: 0,
                          validator: (value) {
                            if(value == null)return ("Select a bank");
                            if(value == "Choose Bank") return ("Select a  valid bank");
                            return null;
                          },
                          decoration: textInputDecoration.copyWith(
                              filled: true,
                              fillColor: AppColors.white,
                              hintStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500
                              ),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primaryGrey)
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primaryGrey)
                              )
                          ),
                          icon: const Icon(Icons.keyboard_arrow_right),
                          value: selectedValue ?? "Choose Bank", // Set the current value
                          items: _dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              if(newValue == null)return;
                              selectedValue = newValue;
                              setFormState();// Update the selected value
                            });
                          },
                        ),
                   ],),
                 ),
                  const Gap(40),
                  BusyButton(
                    title: "Continue",
                    onTap: () {},
                  )
                ],
              )),
        ),
      ),
    );
  }
}
