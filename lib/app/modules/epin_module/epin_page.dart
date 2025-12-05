import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/modules/epin_module/epin_controller.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/constants/textField.dart';

class EpinPage extends GetView<EpinController> {
  const EpinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'E-pin',
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // network selection
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: controller.networks.map((network) {
                    final isSelected = controller.selectedNetwork == network['code'];
                    return GestureDetector(
                      onTap: () => controller.selectNetwork(network['code']!),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Image.asset(
                            network['image']!,
                            width: 45,
                            height: 45,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: TextSemiBold(
                                    network['code']![0],
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                const Gap(30),
                
                // recipient
                TextSemiBold(
                  'Recipient',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                TextFormField(
                  controller: controller.recipientController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontFamily: AppFonts.manRope),
                  decoration: textInputDecoration.copyWith(
                    hintText: 'e.g 0123456789',
                    hintStyle: const TextStyle(
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const Gap(25),
                
                // amount
                TextSemiBold(
                  'Amount',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                TextFormField(
                  readOnly: true,
                  style: TextStyle(fontFamily: AppFonts.manRope),
                  decoration: textInputDecoration.copyWith(
                    hintText: '100-50,000',
                    hintStyle: const TextStyle(
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an amount';
                    }
                    return null;
                  },
                ),
                const Gap(25),
                
                // quantity
                TextSemiBold(
                  'Quantity',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                TextFormField(
                  controller: controller.quantityController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontFamily: AppFonts.manRope),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: textInputDecoration.copyWith(
                    hintText: '1-10',
                    hintStyle: const TextStyle(
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    final qty = int.tryParse(value);
                    if (qty == null || qty < 1 || qty > 10) {
                      return 'Quantity must be between 1 and 10';
                    }
                    return null;
                  },
                ),
                const Gap(40),
                
                // pay button
                BusyButton(
                  onTap: () => controller.proceedToPurchase(),
                  title: 'Pay',
                ),
                const Gap(20),
                
                // info text
                Center(
                  child: TextSemiBold(
                    'A copy of the pin and the instructions will be sen to your email',
                    fontSize: 12,
                    color: AppColors.primaryColor.withOpacity(0.7),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
