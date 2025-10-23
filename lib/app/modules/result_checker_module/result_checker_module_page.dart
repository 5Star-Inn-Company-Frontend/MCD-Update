import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './result_checker_module_controller.dart';

class ResultCheckerModulePage extends GetView<ResultCheckerModuleController> {
    
    const ResultCheckerModulePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Obx(() => PaylonyAppBarTwo(
                title: controller.pageTitle.value,
                elevation: 0,
                centerTitle: false,
                actions: const [],
              )),
            ),
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
                      const Text("Price: ₦1200", style: TextStyle(
                        color: Color(0xffFF9F9F),
                        fontWeight: FontWeight.w500
                      )),
                    ],
                  ),
                  const Gap(8),
                  TouchableOpacity(
                    onTap: () => _showExamPicker(context),
                    child: Obx(() => TextFormField(
                      enabled: false,
                      decoration: textInputDecoration.copyWith(
                        filled: true,
                        fillColor: const Color(0xffFFFFFF),
                        suffixIcon: const Icon(Icons.arrow_forward_ios_outlined),
                        hintText: controller.selectedValue.value ?? "NECO",
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
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color(0xffD9D9D9).withOpacity(0.6))
                        ),
                      ),
                    )),
                  ),

                  const Gap(30),
                  TextSemiBold("Quantity"),
                  const Gap(8),
                  TextFormField(
                    controller: controller.amountController,
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
                    child: BusyButton(
                      width: screenWidth(context) * 0.6, 
                      title: "Pay", 
                      onTap: controller.handlePayment,
                    ),
                  ),
                ],
              ),
            )
        );
    }

    void _showExamPicker(BuildContext context) {
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
              mainAxisSize: MainAxisSize.min,
              children: controller.items.map((e) => TouchableOpacity(
                onTap: () {
                  controller.selectExam(e);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffD9D9D9)),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text(e),
                ),
              )).toList()
            ),
          );
        }
      );
    }
}