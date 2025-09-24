
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:flutter/material.dart' show Border, BorderRadius, BorderSide, BoxDecoration, BuildContext, Center, Color, Column, Container, CrossAxisAlignment, EdgeInsets, FontWeight, Icon, Icons, MainAxisAlignment, OutlineInputBorder, RoundedRectangleBorder, Row, Scaffold, SingleChildScrollView, State, StatefulWidget, Text, TextEditingController, TextFormField, TextStyle, Widget, showModalBottomSheet;
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart' show PaylonyAppBarTwo;
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class ResultCheckerScreen extends StatefulWidget {
  const ResultCheckerScreen({super.key});

  @override
  State<ResultCheckerScreen> createState() => _ResultCheckerScreenState();
}

class _ResultCheckerScreenState extends State<ResultCheckerScreen> {
  String? _selectedValue;
  final List<String> items = [
    "Waec",
    "Neco",
    "JAMB"
  ];
  String? selectedValue;

  final TextEditingController _phone = TextEditingController();
  final _amount = TextEditingController();


  @override
  void initState() {
    if(mounted) {
      setState(() {
        selectedValue = items.first;
      });
    }

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
        appBar: const PaylonyAppBarTwo(title: "Result Checker", elevation: 0, centerTitle: false, actions: [

        ],),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold("Fill out the form below and get your request in your mail inbox"),

              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSemiBold("Select Exam"),
                  const Text("Price: ₦1200",style: TextStyle(
                    color: Color(0xffFF9F9F),
                    fontWeight: FontWeight.w500
                  ),),
                ],
              ),
              const Gap(8),
              TouchableOpacity(
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            border: const Border.fromBorderSide(BorderSide(color: AppColors.primaryGrey))
                          ),
                          child: Column(
                            children: items.map((e) => TouchableOpacity(
                              onTap: () {
                                if(e == null || !context.mounted)return;
                                setState(() {
                                  _selectedValue = e;
                                  context.pop(context);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xffD9D9D9)),
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: Text(e.toString()),),
                            )).toList()
                          ),
                        );
                      }
                  );
                },
                child: TextFormField(
                  controller: _phone,
                  enabled: false,
                    decoration: textInputDecoration.copyWith(
                      filled: true,
                      fillColor: const Color(0xffFFFFFF),
                      suffixIcon: const Icon(Icons.arrow_forward_ios_outlined),
                      hintText: _selectedValue ?? "NECO",
                      hintStyle: const TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.w500
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.6))
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.6))
                      ),
                      disabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.6))
                      ),
                    ),
                ),
              ),

              const Gap(30),
              TextSemiBold("Quantity"),
              const Gap(8),
              TextFormField(
                controller: _amount,
                decoration: textInputDecoration.copyWith(
                  filled: true,
                  fillColor: const Color(0xffFFFFFF),
                  hintText: "1-10",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.6))
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.6))
                  ),
                ),
              ),
              const Gap(70),
              Center(
                child: BusyButton(width: screenWidth(context) * 0.6, title: "Pay", onTap:(){

                }),
              ),
            ],
          ),
        )
    );
  }
}