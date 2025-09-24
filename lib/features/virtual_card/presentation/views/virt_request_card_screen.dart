import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/virtual_card/presentation/views/virt_card_application_screen.dart';
import 'package:mcd/features/virtual_card/presentation/widgets/card_button.dart';
import 'package:mcd/features/virtual_card/presentation/widgets/card_dropdown.dart';
import 'package:mcd/features/virtual_card/presentation/widgets/cardtextfield.dart';

class VirtRequestCardScreen extends StatefulWidget {
  const VirtRequestCardScreen({super.key});

  @override
  State<VirtRequestCardScreen> createState() => _VirtRequestCardScreenState();
}

class _VirtRequestCardScreenState extends State<VirtRequestCardScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? selectedDob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Request For Card",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight(context) * 0.8,
              child: Column(
                children: [
                  Gap(20.h),
              
                  Cardtextfield(tfieldname: 'Full Name', controller: nameController),
              
                  Gap(10.h),
              
                  Cardtextfield(tfieldname: 'Email Address', controller: emailController),
              
                  Gap(10.h),
              
                  CardDropdown(ddname: 'DOB', selectedValue: selectedDob, 
                    listdd: const [
                      DropdownMenuItem(value: 'January', child: Text('January')),
                      DropdownMenuItem(value: 'February', child: Text('February')),
                    ],
                  ),
              
                  Gap(10.h),
              
                  Cardtextfield(tfieldname: 'Phone Number', controller: phoneNumberController)
                ]
              ),
            ),

            CardButton(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) 
                  => VirtCardAppScreen(
                    name: nameController.text,
                    email: emailController.text,
                    number: phoneNumberController.text,
                    dob: selectedDob.toString(),
                    insuranceFee: '2.00',
                    maintenanceFee: '0.50'
                )));
              },
              text: 'Proceed'
            )
          ],
        )
      )
    );
  }
}