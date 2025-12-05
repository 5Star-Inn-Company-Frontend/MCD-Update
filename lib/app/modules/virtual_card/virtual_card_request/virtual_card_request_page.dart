import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            
            // Currency Dropdown 1
            TextSemiBold(
              'Currency',
              fontSize: 14,
              color: Colors.black87,
            ),
            const Gap(8),
            Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCurrency1.value.isEmpty 
                    ? null 
                    : controller.selectedCurrency1.value,
                hint: TextSemiBold(
                  'Select',
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                isExpanded: true,
                items: ['Dollar', 'Naira', 'Pound', 'Euro']
                    .map((currency) => DropdownMenuItem(
                          value: currency,
                          child: TextSemiBold(currency, fontSize: 14),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedCurrency1.value = value;
                  }
                },
              ),
            )),
            const Gap(24),
            
            // Currency Dropdown 2 (Card Type)
            TextSemiBold(
              'Currency',
              fontSize: 14,
              color: Colors.black87,
            ),
            const Gap(8),
            Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCurrency2.value.isEmpty 
                    ? null 
                    : controller.selectedCurrency2.value,
                hint: TextSemiBold(
                  'Select',
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                isExpanded: true,
                items: ['Master Card', 'Visa Card', 'Verve Card']
                    .map((cardType) => DropdownMenuItem(
                          value: cardType,
                          child: TextSemiBold(cardType, fontSize: 14),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedCurrency2.value = value;
                  }
                },
              ),
            )),
            const Gap(24),
            
            // Top Up Amount
            TextSemiBold(
              'Top Up Amount',
              fontSize: 14,
              color: Colors.black87,
            ),
            const Gap(8),
            TextFormField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const Gap(40),
            
            // Proceed Button
            BusyButton(
              title: 'Proceed',
              onTap: () {
                if (controller.selectedCurrency1.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please select currency',
                    backgroundColor: AppColors.errorBgColor,
                    colorText: AppColors.textSnackbarColor,
                  );
                  return;
                }
                if (controller.selectedCurrency2.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please select card type',
                    backgroundColor: AppColors.errorBgColor,
                    colorText: AppColors.textSnackbarColor,
                  );
                  return;
                }
                if (controller.amountController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter amount',
                    backgroundColor: AppColors.errorBgColor,
                    colorText: AppColors.textSnackbarColor,
                  );
                  return;
                }
                
                Get.toNamed(
                  Routes.VIRTUAL_CARD_APPLICATION,
                  arguments: {
                    'currency': controller.selectedCurrency1.value,
                    'cardType': controller.selectedCurrency2.value,
                    'amount': controller.amountController.text,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}