import 'package:flutter/material.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class NinValidationScreen extends StatefulWidget {
  const NinValidationScreen({super.key});

  @override
  State<NinValidationScreen> createState() => _NinValidationScreenState();
}

class _NinValidationScreenState extends State<NinValidationScreen> {
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
        appBar: const PaylonyAppBarTwo(
          title: "NIN Validation",
          elevation: 0,
          centerTitle: false,
          actions: [],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold(
                  "This service is for people that want to make their NIN available for validation immediately without waiting for long. Enter the NIN and you will get response within 24hours"),
              const Gap(4),
              TextSemiBold(
                  "Enter the NIN and you will get response within 24hours",
                  color: AppColors.background),
              const Gap(30),
              const Text(
                "Fee: ₦2,500",
                style: TextStyle(fontSize: 22),
              ),
              const Gap(40),
              TextSemiBold("Enter your/customer NIN",
                  color: AppColors.background),
              const Gap(6),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  filled: true,
                  fillColor: const Color(0xffFFFFFF),
                  hintText: "0123456",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xffD9D9D9).withOpacity(0.6))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color(0xffD9D9D9).withOpacity(0.6))),
                ),
              ),
              const Gap(70),
              Center(
                child: BusyButton(
                    width: screenWidth(context) * 0.6,
                    title: "Submit",
                    onTap: () {}),
              ),
            ],
          ),
        ));
  }
}
