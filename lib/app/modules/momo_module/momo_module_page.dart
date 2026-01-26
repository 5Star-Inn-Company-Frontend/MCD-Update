import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/modules/momo_module/momo_module_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';

class MomoModulePage extends GetView<MomoModuleController> {
  const MomoModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'Momo Top Up',
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.currentStage.value == 1) {
          return _buildSuccessView();
        }
        return _buildFormView();
      }),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your bank and the amount to generate a ussd code quickly',
              style: TextStyle(
                fontFamily: AppFonts.manRope,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const Gap(24),

            // Currency Dropdown
            TextSemiBold('Select currency',
                fontSize: 14, color: Colors.black87),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() => DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select currency',
                          style: TextStyle(
                              fontFamily: AppFonts.manRope,
                              color: Colors.grey)),
                      value: controller.selectedCurrency.value,
                      items: controller.currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(fontFamily: AppFonts.manRope)),
                        );
                      }).toList(),
                      onChanged: controller.onCurrencyChanged,
                    )),
              ),
            ),
            const Gap(24),

            // Provider Dropdown
            TextSemiBold('Select Mobile Money Provider',
                fontSize: 14, color: Colors.black87),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() => DropdownButton<Map<String, dynamic>>(
                      isExpanded: true,
                      hint: Text('Select Mobile Money Provider',
                          style: TextStyle(
                              fontFamily: AppFonts.manRope,
                              color: Colors.grey)),
                      value: controller.selectedProvider.value,
                      items: controller.providers
                          .map((Map<String, dynamic> provider) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: provider,
                          child: Row(
                            children: [
                              if (provider['logo'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(provider['logo'],
                                      width: 24,
                                      height: 24,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox()),
                                ),
                              Text(provider['name'] ?? '',
                                  style:
                                      TextStyle(fontFamily: AppFonts.manRope)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          controller.selectedProvider.value = val,
                    )),
              ),
            ),
            const Gap(24),

            // Phone Number
            TextSemiBold('Enter Mobile Money Number',
                fontSize: 14, color: Colors.black87),
            const Gap(8),
            TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(fontFamily: AppFonts.manRope),
              decoration: InputDecoration(
                hintText: '',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const Gap(24),

            // Amount
            TextSemiBold('Amount', fontSize: 14, color: Colors.black87),
            const Gap(8),
            TextFormField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(fontFamily: AppFonts.manRope),
              decoration: InputDecoration(
                hintText: '12345.00',
                hintStyle: TextStyle(
                    fontFamily: AppFonts.manRope, color: AppColors.primaryGrey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),

            const Gap(12),
            // Exchange Rate Display (Placeholder logic per screenshot)
            // Rh 00:00 <-> # 00:00
            Row(
              children: [
                Text('Rh 00:00',
                    style: TextStyle(
                        fontFamily: AppFonts.manRope,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.compare_arrows,
                      color: AppColors.primaryColor, size: 20),
                ),
                Text('# 00:00',
                    style: TextStyle(
                        fontFamily: AppFonts.manRope,
                        fontWeight: FontWeight.bold)),
              ],
            ),

            const Gap(40),
            Obx(() => BusyButton(
                  title: 'Proceed',
                  isLoading: controller.isSubmitting.value,
                  onTap: controller.proceed,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check your phone to complete the transaction',
            style: TextStyle(
                fontFamily: AppFonts.manRope,
                fontSize: 16,
                color: Colors.black87),
          ),
          const Gap(24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successBgColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletPoint(
                    'You will receive a notification on your phone to authorize the payment.'),
                const Gap(8),
                _buildBulletPoint(
                    'Proceed to make the transfer by accepting the prompt on your phone'),
              ],
            ),
          ),
          const Spacer(),
          BusyButton(
            title: 'I have completed the prompt',
            onTap: () {
              Get.back(); // Or navigate appropriately
              Get.snackbar('Success', 'Transaction Pending',
                  backgroundColor: AppColors.successBgColor,
                  colorText: Colors.white);
            },
          ),
          const Gap(40),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: CircleAvatar(radius: 2, backgroundColor: Colors.black87),
        ),
        const Gap(8),
        Expanded(
            child: Text(text,
                style: TextStyle(fontFamily: AppFonts.manRope, fontSize: 14))),
      ],
    );
  }
}
