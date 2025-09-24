import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/utils/functions.dart';
import 'package:mcd/features/home/presentation/views/verify_jamb_account.dart';

class JambScreen extends StatefulWidget {
  const JambScreen({super.key});

  @override
  State<JambScreen> createState() => _JambScreenState();
}

class _JambScreenState extends State<JambScreen> {
  int index = 1;
  String selectedType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "Jamb",
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold("Select type"),
              const Gap(25),
              rowcard('Direct Entry (DE)', 6200, 1),
              rowcard('UTME PIN (with mock)', 7700, 2),
              rowcard('UTME PIN (without mock) ', 6200, 3)
            ],
          ))),
    );
  }

  Widget rowcard(String name, double? amount, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TouchableOpacity(
        onTap: () {
          setState(() {
            index = value;
            selectedType = name;
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const VerifyJamb()));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: index == value
                    ? AppColors.primaryColor
                    : AppColors.primaryGrey,
                width: index == value ? 1.2 : 0.8,
              ),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                TextSemiBold(name),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: TextSemiBold('-'),
                ),
                TextSemiBold(
                  Functions.money(amount!, '₦'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
