import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class VerifyJamb extends StatefulWidget {
  const VerifyJamb({super.key});

  @override
  State<VerifyJamb> createState() => _VerifyJambState();
}

class _VerifyJambState extends State<VerifyJamb> {
  final TextEditingController _recipient = TextEditingController();
  final TextEditingController _profilecode = TextEditingController();
  @override
  void dispose() {
    _recipient.dispose();
    _profilecode.dispose();
    super.dispose();
  }

  bool visible = false;
  Widget itemRow(String name, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(
            name,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          TextSemiBold(
            value,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "Verify account",
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: visible == false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            TextSemiBold(
                                'You will get ₦10 in your commission wallet'),
                          ],
                        ),
                      ),
                    ),
                    Gap(30),
                    TextSemiBold("Enter profile code"),
                    Gap(8),
                    TextFormField(
                      controller: _profilecode,
                      decoration: textInputDecoration.copyWith(
                        filled: true,
                        fillColor: Color(0xffFFFFFF),
                        hintText: "Profile code",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffD9D9D9).withOpacity(0.6))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffD9D9D9).withOpacity(0.6))),
                      ),
                    ),
                    Gap(70),
                    Center(
                      child: BusyButton(
                          width: screenWidth(context) * 0.6,
                          title: "Verify Account",
                          onTap: () {
                            setState(() {
                              visible = true;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visible == true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Material(
                      elevation: 2,
                      color: AppColors.white,
                      shadowColor: Color(0xff000000).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 18),
                        child: Column(
                          children: [
                            itemRow("Service", "PAYTV"),
                            itemRow("Network", "JAMB"),
                            itemRow("Amount", "₦6200.00"),
                            itemRow("ATM/Wallet", "1.5% / ₦0.00"),
                            itemRow("Total Due", "₦6293.00 / ₦6200.00"),
                          ],
                        ),
                      ),
                    ),
                    Gap(8),
                    Gap(30),
                    TextSemiBold("Recipient"),
                    Gap(8),
                    TextFormField(
                      controller: _recipient,
                      decoration: textInputDecoration.copyWith(
                        filled: true,
                        fillColor: Color(0xffFFFFFF),
                        hintText: "0123456789",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffD9D9D9).withOpacity(0.6))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffD9D9D9).withOpacity(0.6))),
                      ),
                    ),
                    Gap(70),
                    Center(
                      child: BusyButton(
                          width: screenWidth(context) * 0.6,
                          title: "Pay",
                          onTap: () {}),
                    ),
                  ],
                ),
              ),
            ],
          ))),
    );
  }
}
