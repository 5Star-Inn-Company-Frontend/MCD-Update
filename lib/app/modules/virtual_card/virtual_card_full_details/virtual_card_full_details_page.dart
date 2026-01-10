import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import './virtual_card_full_details_controller.dart';

class VirtualCardFullDetailsPage extends GetView<VirtualCardFullDetailsController> {
  const VirtualCardFullDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Virtual Card",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Half - Card with Rotation Animation
          Expanded(
            flex: 1,
            child: Center(
              child: Obx(() => TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                tween: Tween(
                  begin: 0.0,
                  end: controller.isDetailsVisible.value ? 1.0 : 0.0,
                ),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateY(value * 1.5708), // 90 degrees rotation on Y-axis (flip sideways)
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Image.asset(
                        'assets/images/virtual_card/vc_transaction.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              )),
            ),
          ),
          
          // Show/Hide Detail Button
          Obx(() => GestureDetector(
            onTap: controller.toggleDetails,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextSemiBold(
                    controller.isDetailsVisible.value ? 'Hide Detail' : 'Show Detail',
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                  const Gap(8),
                  Icon(
                    controller.isDetailsVisible.value 
                        ? Icons.visibility_off_outlined 
                        : Icons.visibility_outlined,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          )),
          
          // Bottom Half - Details with Falling Animation
          Expanded(
            flex: 1,
            child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(
                0,
                controller.isDetailsVisible.value ? 0 : 500, // Slide down from above
                0,
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: controller.isDetailsVisible.value ? 1.0 : 0.0,
                child: Visibility(
                  visible: controller.isDetailsVisible.value,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        'Name',
                        'Oluwa wa',
                      ),
                      const Gap(20),
                      _buildDetailRow(
                        context,
                        'Card Number',
                        '2138 2138 2138 2138',
                        showCopy: true,
                      ),
                      const Gap(20),
                      _buildDetailRow(
                        context,
                        'CVV',
                        '381',
                      ),
                      const Gap(20),
                      _buildDetailRow(
                        context,
                        'Expiry Date',
                        'Dec 2024',
                      ),
                      const Gap(20),
                      _buildDetailRow(
                        context,
                        'Currency',
                        'Dollar',
                      ),
                      const Gap(40),
                      
                      // Delete Card Button
                      TextButton(
                        onPressed: () {
                          _showDeleteConfirmation(context);
                        },
                        child: TextSemiBold(
                          'Delete Card',
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            )),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(BuildContext context, String label, String value, {bool showCopy = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextSemiBold(
          label,
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
        Row(
          children: [
            TextSemiBold(
              value,
              fontSize: 14,
              color: Colors.black87,
            ),
            if (showCopy) ...[
              const Gap(8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  Get.snackbar(
                    'Copied',
                    'Card number copied to clipboard',
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    colorText: AppColors.primaryColor,
                    duration: const Duration(seconds: 2),
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(20),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
  
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBold(
                'Delete Card',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const Gap(16),
              TextSemiBold(
                'Are you sure you want to delete this card?',
                fontSize: 15,
                color: Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
              const Gap(30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TextSemiBold(
                        'No',
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Card deleted successfully',
                          backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                          colorText: const Color(0xFF4CAF50),
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(20),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TextBold(
                        'Yes',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
