
import 'package:flutter/material.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class EpinScreen extends StatefulWidget {
  const EpinScreen({super.key});

  @override
  State<EpinScreen > createState() => _EpinScreenState();
}

class _EpinScreenState extends State<EpinScreen> {
  String? _selectedValue;
  final List<String> items = [
    "assets/images/betti.png"
        "assets/images/airtel.png",
    // AppAsset.mtn,
    // AppAsset.mtn,
  ];
  String? selectedValue;

  final TextEditingController _phone = TextEditingController();
  final _amount = TextEditingController();


  @override
  void initState() {
    selectedValue = items.first;
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _amount.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(title: "E-pin", elevation: 0, centerTitle: false, actions: [

        ],),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold(""),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.5),
                  border: Border.all(
                      color: const Color(0xffD9D9D9),
                      width: 1.0
                  ),

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset("assets/images/mtn.png", width: 70, height: 80,),
                    Image.asset("assets/images/airtel.png", width: 70, height: 80),
                    Image.asset("assets/images/etisalat.png", width: 70, height: 80),
                    Image.asset("assets/images/glo.png", width: 70, height: 80)
                          ]
                ),
              ),
              const Gap(20),
              TextSemiBold("Recipient", color: AppColors.background),
              const Gap(6),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  filled: true,
                    fillColor: const Color(0xffFFFFFF),
                    hintText: "e.g 0123456789",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.5))
                  )
                ),
              ),
              const Gap(25),
              TextSemiBold("Amount", color: AppColors.background),
              const Gap(6),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    filled: true,
                    fillColor: const Color(0xffFFFFFF),
                    hintText: "100-50,000",

                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.5))
                    )
                ),
              ),

              const Gap(25),
              TextSemiBold("Quantity", color: AppColors.background),
              const Gap(6),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    filled: true,
                    fillColor: const Color(0xffFFFFFF),
                    hintText: "1-5",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.5))
                    )
                ),
              ),
              const Gap(50),
              Center(
                child: BusyButton(width: screenWidth(context) * 0.6, title: "Pay", onTap:(){

                }),
              ),
              const Gap(30),
              TextSemiBold("A copy of the pin and the instructions will be sen to your email", textAlign: TextAlign.center, color: const Color(0xffFF9F9F),)
            ],
          ),
        )
    );
  }
}
