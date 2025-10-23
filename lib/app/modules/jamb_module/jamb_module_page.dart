import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './jamb_module_controller.dart';

class JambModulePage extends GetView<JambModuleController> {
    
    const JambModulePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: const PaylonyAppBarTwo(
              title: "JAMB",
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
                    "Select Type",
                    fontSize: 16,
                  ),
                  const Gap(15),
                  
                  ...controller.options.map((option) => Obx(() {
                    final isSelected = controller.selectedOption.value == option['value'];
                    return TouchableOpacity(
                      onTap: () => controller.selectOption(option['value']!),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryColor : Colors.grey.shade100,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option['title']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
                  
                  const Gap(40),
                  Center(
                    child: BusyButton(
                      width: screenWidth(context) * 0.6,
                      title: "Continue",
                      onTap: controller.proceedToVerify,
                    ),
                  ),
                ],
              ),
            ),
        );
    }
}