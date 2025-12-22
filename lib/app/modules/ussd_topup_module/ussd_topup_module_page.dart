import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/modules/ussd_topup_module/ussd_topup_module_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/fonts.dart';

class UssdTopupModulePage extends GetView<UssdTopupModuleController> {
  const UssdTopupModulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'USSD Top-up',
        centerTitle: false,
      ),
      body: SafeArea(
        child: _buildFormView(),
      ),
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
            const Gap(10),
            
            // Bank Selection
            TextSemiBold(
              'Select Bank',
              fontSize: 14,
              color: AppColors.primaryGrey2,
            ),
            const SizedBox(height: 8),
            Obx(() => InkWell(
              onTap: () => _showBankSelectionBottomSheet(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryGrey2.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        controller.selectedBank.value,
                        style: TextStyle(
                          fontFamily: AppFonts.manRope,
                          fontSize: 14,
                          color: controller.selectedBank.value == 'Choose bank'
                              ? AppColors.primaryGrey2.withOpacity(0.5)
                              : Colors.black,
                        ),
                    ),
                    Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryGrey2,
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 20),
            
            // Account Number
            TextSemiBold(
              'Enter Account Number',
              fontSize: 14,
              color: AppColors.primaryGrey2,
            ),
            const Gap(8),
            TextFormField(
              controller: controller.accountNumberController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              style: TextStyle(fontFamily: AppFonts.manRope),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Enter account number',
                hintStyle: TextStyle(fontFamily: AppFonts.manRope, color: AppColors.primaryGrey2.withOpacity(0.5)),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryGrey2.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryGrey2.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
              onChanged: (value) {
                if (value.length == 10) {
                  controller.validateAccountNumber();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter account number';
                }
                if (value.length != 10) {
                  return 'Account number must be 10 digits';
                }
                return null;
              },
            ),
            
            // Account Name Display
            Obx(() {
              if (controller.isValidatingAccount.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextSemiBold(
                        'Validating account...',
                        fontSize: 12,
                        color: AppColors.primaryGrey2,
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.accountName.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextSemiBold(
                          controller.accountName.value,
                          fontSize: 12,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 20),
            
            // Amount
            TextSemiBold(
              'Enter Amount',
              fontSize: 14,
              color: AppColors.primaryGrey2,
            ),
            const Gap(8),
            TextFormField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontFamily: AppFonts.manRope),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: TextStyle(fontFamily: AppFonts.manRope, color: AppColors.primaryGrey2.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryGrey2.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primaryGrey2.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            
            // Generate Button
            Obx(() => BusyButton(
              title: 'Generate USSD Code',
              isLoading: controller.isGeneratingCode.value,
              onTap: () => controller.generateCode(),
            )),
            const SizedBox(height: 30),
            
            // Generated Code Section (shown after generation)
            Obx(() {
              if (controller.generatedCode.value.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider
                  Divider(
                    color: AppColors.primaryGrey2.withOpacity(0.2),
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  
                  // Success Icon and Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 24,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBold(
                              'Code Generated!',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            const Gap(4),
                            TextSemiBold(
                              'Dial the code below to complete top-up',
                              fontSize: 12,
                              color: AppColors.primaryGrey2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // USSD Code Display
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            controller.generatedCode.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              letterSpacing: 2,
                              fontFamily: AppFonts.manRope,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Action Buttons Row
                  Row(
                    children: [
                      // Copy Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => controller.copyCode(),
                          icon: const Icon(
                            Icons.copy,
                            size: 20,
                          ),
                          label: const Text(
                            'Copy Code',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.manRope,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            side: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Dial Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => controller.dialCode(),
                          icon: const Icon(
                            Icons.phone,
                            size: 20,
                          ),
                          label: const Text(
                            'Dial Code',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.manRope,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Close/Clear Button
                  Center(
                    child: TextButton.icon(
                      onPressed: () => controller.clearGeneratedCode(),
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                      ),
                      label: TextSemiBold(
                        'Clear Code',
                        fontSize: 13,
                        color: AppColors.primaryGrey2,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGrey2,
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  void _showBankSelectionBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryGrey2.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBold(
                    'Select Bank',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller.bankSearchController,
                onChanged: (value) => controller.bankSearchQuery = value,
                decoration: InputDecoration(
                  hintText: 'Search banks...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryGrey2.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primaryGrey2.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            
            // Banks List
            Expanded(
              child: Obx(() {
                if (controller.isLoadingBanks.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }
                
                final banks = controller.filteredBanks;
                
                if (banks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.primaryGrey2.withOpacity(0.5),
                        ),
                        const Gap(16),
                        TextSemiBold(
                          'No banks found',
                          fontSize: 14,
                          color: AppColors.primaryGrey2,
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: banks.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.primaryGrey2.withOpacity(0.2),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final bank = banks[index];
                    return ListTile(
                      onTap: () => controller.selectBank(
                        bank['name']!,
                        bank['code']!,
                        bank['ussd']!,
                      ),
                      title: TextSemiBold(
                        bank['name']!,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.primaryGrey2,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
