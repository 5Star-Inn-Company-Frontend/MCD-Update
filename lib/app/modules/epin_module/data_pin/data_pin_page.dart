import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/modules/epin_module/data_pin/data_pin_controller.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/fonts.dart';

class DataPinPage extends GetView<DataPinController> {
  const DataPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'Data-pin',
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
                      final isSelected = controller.selectedNetwork == network['code'];
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
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: TextSemiBold(
                                    network['code']![0],
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
                const Gap(24),
                
                // Data Pin Type
                TextSemiBold(
                  'Data Pin Type',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(8),
                Obx(() => GestureDetector(
                  onTap: () => controller.showPlanSelectionBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGrey2.withOpacity(0.05),
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            controller.selectedType.isEmpty 
                              ? 'Select Type' 
                              : controller.selectedType,
                            style: TextStyle(
                              fontFamily: AppFonts.manRope,
                              color: controller.selectedType.isEmpty 
                                ? AppColors.primaryGrey2.withOpacity(0.4)
                                : AppColors.background,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                )),
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
                BusyButton(
                  title: "Pay",
                  onTap: () => controller.proceedToPurchase(context),
                ),
                const Gap(40),
                
                // Info text
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
