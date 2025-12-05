import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/modules/airtime_pin_module/airtime_pin_module_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/fonts.dart';

class AirtimePinModulePage extends GetView<AirtimePinModuleController> {
  const AirtimePinModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'Airtime Pin',
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
                // Description
                TextSemiBold(
                  'Purchase airtime pins and receive them via email',
                  fontSize: 14,
                  color: AppColors.background,
                ),
                const Gap(30),
                
                // Network Selection
                TextSemiBold(
                  'Select Network',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(12),
                Obx(() => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.networks.map((network) {
                      final isSelected = controller.selectedNetwork.value == network['code'];
                      return GestureDetector(
                        onTap: () => controller.selectNetwork(network['code']!),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryColor : Colors.transparent,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            network['image']!,
                            width: 60,
                            height: 60,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
                const Gap(30),
                
                // Recipient Phone Number
                TextSemiBold(
                  'Recipient Phone Number',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                TextFormField(
                  controller: controller.recipientController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  style: TextStyle(fontFamily: AppFonts.manRope),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    hintText: '08012345678',
                    hintStyle: TextStyle(
                      color: AppColors.primaryGrey2.withOpacity(0.4),
                      fontFamily: AppFonts.manRope,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.primaryGrey2.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipient phone number';
                    }
                    if (value.length != 11) {
                      return 'Phone number must be 11 digits';
                    }
                    if (!value.startsWith('0')) {
                      return 'Phone number must start with 0';
                    }
                    return null;
                  },
                ),
                const Gap(24),
                
                // Amount
                TextSemiBold(
                  'Amount (₦100 - ₦50,000)',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                TextFormField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontFamily: AppFonts.manRope),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: '1000',
                    hintStyle: TextStyle(
                      color: AppColors.primaryGrey2.withOpacity(0.4),
                      fontFamily: AppFonts.manRope,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                      child: Text(
                        '₦',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: AppColors.primaryGrey2.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Invalid amount';
                    }
                    if (amount < 100 || amount > 50000) {
                      return 'Amount must be between ₦100 and ₦50,000';
                    }
                    return null;
                  },
                ),
                const Gap(24),
                
                // Quantity
                TextSemiBold(
                  'Quantity (1 - 10)',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                Row(
                  children: [
                    // Decrement button
                    GestureDetector(
                      onTap: controller.decrementQuantity,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(12),
                    // Quantity input
                    Expanded(
                      child: TextFormField(
                        controller: controller.quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.manRope,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.primaryGrey2.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter quantity';
                          }
                          final quantity = int.tryParse(value);
                          if (quantity == null) {
                            return 'Invalid';
                          }
                          if (quantity < 1 || quantity > 10) {
                            return '1-10';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Gap(12),
                    // Increment button
                    GestureDetector(
                      onTap: controller.incrementQuantity,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(40),
                
                // Pay Button
                Obx(() => BusyButton(
                  title: "Pay",
                  isLoading: controller.isProcessing.value,
                  onTap: () => controller.processPayment(),
                )),
                const Gap(40),
                Center(
                  child: TextSemiBold(
                    'A copy of the pin and the instructions will be sent to your email',
                    fontSize: 13,
                    color: AppColors.errorBgColor,
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
