import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './result_checker_module_controller.dart';
import 'package:mcd/core/utils/amount_formatter.dart';

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
                      Text("Price: ₦${AmountUtil.formatFigure(1200)}", style: const TextStyle(
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
                  TextSemiBold("Enter Quantity"),
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text options
                ...controller.items.map((e) => TouchableOpacity(
                  onTap: () {
                    controller.selectExam(e);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffD9D9D9)),
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 15, fontFamily: AppFonts.manRope)),
                  ),
                )).toList(),
                const Gap(20),
                // Exam logos in grid
                // GridView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     childAspectRatio: 1.5,
                //     crossAxisSpacing: 12,
                //     mainAxisSpacing: 12,
                //   ),
                //   itemCount: controller.exams.length,
                //   itemBuilder: (context, index) {
                //     final exam = controller.exams[index];
                //     return TouchableOpacity(
                //       onTap: () {
                //         controller.selectExamByObject(exam);
                //         Navigator.pop(context);
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(16),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           border: Border.all(color: const Color(0xffE0E0E0)),
                //           borderRadius: BorderRadius.circular(12),
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.05),
                //               blurRadius: 4,
                //               offset: const Offset(0, 2),
                //             ),
                //           ],
                //         ),
                //         child: Image.asset(
                //           exam['logo']!,
                //           fit: BoxFit.contain,
                //           errorBuilder: (context, error, stackTrace) => 
                //             Center(child: Text(exam['name']!, 
                //               style: const TextStyle(fontWeight: FontWeight.bold))),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          );
        }
      );
    }
}