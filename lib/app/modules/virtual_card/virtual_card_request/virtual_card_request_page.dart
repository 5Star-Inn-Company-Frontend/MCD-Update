import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/virtual_card/virtual_card_request/widgets/card_button.dart';
import 'package:mcd/app/modules/virtual_card/virtual_card_request/widgets/card_dropdown.dart';
import 'package:mcd/app/modules/virtual_card/virtual_card_request/widgets/cardtextfield.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './virtual_card_request_controller.dart';

class VirtualCardRequestPage extends GetView<VirtualCardRequestController> {
  const VirtualCardRequestPage({super.key});

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
                  Cardtextfield(
                      tfieldname: 'Full Name',
                      controller: controller.nameController),
                  Gap(10.h),
                  Cardtextfield(
                      tfieldname: 'Email Address',
                      controller: controller.emailController),
                  Gap(10.h),
                  Obx(() => CardDropdown(
                        ddname: 'DOB',
                        selectedValue: controller.selectedDob,
                        listdd: const [
                          DropdownMenuItem(
                              value: 'January', child: Text('January')),
                          DropdownMenuItem(
                              value: 'February', child: Text('February')),
                        ],
                      )),
                  Gap(10.h),
                  Cardtextfield(
                      tfieldname: 'Phone Number',
                      controller: controller.phoneNumberController)
                ],
              ),
            ),
            CardButton(
              onTap: () {
                Get.toNamed(
                  Routes.VIRTUAL_CARD_APPLICATION,
                  arguments: {
                    'name': controller.nameController.text,
                    'email': controller.emailController.text,
                    'number': controller.phoneNumberController.text,
                    'dob': controller.selectedDob.toString(),
                    'insuranceFee': '2.00',
                    'maintenanceFee': '0.50'
                  },
                );
              },
              text: 'Proceed',
            )
          ],
        ),
      ),
    );
  }
}
