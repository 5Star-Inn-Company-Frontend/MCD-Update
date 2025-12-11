import 'package:flutter/services.dart';
import 'package:mcd/core/import/imports.dart';
import './virtual_card_details_controller.dart';

class VirtualCardDetailsPage extends GetView<VirtualCardDetailsController> {
  const VirtualCardDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Virtual Card",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(10),
            
            // My Card Title
            TextBold(
              'My Card',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            const Gap(30),
            
            // Card Carousel
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, animValue, child) {
                return Opacity(
                  opacity: animValue.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - animValue)),
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                height: 220,
                child: PageView.builder(
                controller: controller.pageController,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: controller.pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (controller.pageController.position.haveDimensions) {
                        value = controller.pageController.page! - index;
                        value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: Curves.easeInOut.transform(value) * 220,
                          width: Curves.easeInOut.transform(value) * 350,
                          child: child,
                        ),
                      );
                    },
                    child: index == 0
                        ? _buildVirtualCard(
                            balance: '\$4,408.77',
                            cardNumber: '4127 **** *** 5924',
                            color: AppColors.primaryColor,
                            isActive: true,
                          )
                        : _buildVirtualCard(
                            balance: '\$2,150.00',
                            cardNumber: '5138 **** *** 4821',
                            color: const Color(0xFF1E3A8A),
                            isActive: false,
                          ),
                  );
                },
              ),
              ),
            ),
            const Gap(30),
            
            // Action Buttons Row
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    icon: Icons.receipt_long_outlined,
                    label: 'Transactions',
                    onTap: () => Get.toNamed(Routes.VIRTUAL_CARD_TRANSACTIONS),
                  ),
                  _buildActionButton(
                    icon: Icons.ac_unit_outlined,
                    label: 'Freeze',
                    onTap: () => _showFreezeDialog(context),
                  ),
                  _buildActionButton(
                  icon: Icons.credit_card_outlined,
                  label: 'Details',
                  onTap: () => Get.toNamed(Routes.VIRTUAL_CARD_FULL_DETAILS),
                ),
              ],
              ),
            ),
            const Gap(30),
            
            // Deposit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.VIRTUAL_CARD_TOP_UP);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: TextBold(
                  'Deposit',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Gap(30),
            
            // Manage card Section
            TextSemiBold(
              'Manage card',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            const Gap(16),
            
            // Limits Option
            _buildManageOption(
              icon: Icons.speed_outlined,
              iconColor: AppColors.primaryColor,
              label: 'Limits',
              onTap: () => Get.toNamed(Routes.VIRTUAL_CARD_LIMITS),
            ),
            const Gap(12),
            
            // Change PIN Option
            _buildManageOption(
              icon: Icons.lock_outline,
              iconColor: AppColors.primaryColor,
              label: 'Change PIN',
              onTap: () => Get.toNamed(Routes.VIRTUAL_CARD_CHANGE_PIN),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVirtualCard({
    required String balance,
    required String cardNumber,
    required Color color,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mastercard Logo and Contactless Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const Icon(
                Icons.contactless_outlined,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
          const Spacer(),
          
          // Balance
          TextBold(
            balance,
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          const Gap(16),
          
          // Card Number
          TextSemiBold(
            cardNumber,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: [
            Icon(
              icon,
              color: Colors.black87,
              size: 28,
            ),

            TextSemiBold(
              label,
              fontSize: 14,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildManageOption({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const Gap(12),
            TextSemiBold(
              label,
              fontSize: 15,
              color: Colors.black87,
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRowModal(String label, String value, {bool showCopy = false}) {
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
                    backgroundColor: AppColors.successBgColor,
                    colorText: AppColors.textSnackbarColor,
                    duration: const Duration(seconds: 2),
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
  
  void _showFreezeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBold(
                'Freeze',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const Gap(16),
              TextSemiBold(
                'Are you sure you want to freeze your Card',
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
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.snackbar(
                          'Success',
                          'Card has been frozen',
                          backgroundColor: AppColors.successBgColor,
                          colorText: AppColors.textSnackbarColor,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TextBold(
                        'Yes',
                        fontSize: 16,
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
                        'Cancel',
                        fontSize: 16,
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
                          'Card has been deleted',
                          backgroundColor: AppColors.successBgColor,
                          colorText: AppColors.textSnackbarColor,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: TextBold(
                        'Delete',
                        fontSize: 16,
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
