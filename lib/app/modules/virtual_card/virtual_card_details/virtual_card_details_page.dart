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

            // Card Display
            Obx(() {
              if (controller.card.value == null &&
                  controller.isFetchingBalance.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.card.value == null) {
                return const Center(child: Text("Card not found"));
              }

              final card = controller.card.value!;

              return Center(
                child: _buildVirtualCard(
                  balance:
                      '\$${controller.cardBalance.value.toStringAsFixed(2)}',
                  cardNumber:
                      '**** **** **** ${card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : '****'}',
                  color: _getCardColor(card.brand),
                  brand: card.brand,
                  isActive: card.status.toLowerCase() == 'active',
                ),
              );
            }),
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
                    onTap: () {
                      if (controller.card.value != null) {
                        Get.toNamed(Routes.VIRTUAL_CARD_TRANSACTIONS,
                            arguments: {'cardId': controller.card.value!.id});
                      }
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.ac_unit_outlined,
                    label: 'Freeze',
                    onTap: () => _showFreezeDialog(context),
                  ),
                  _buildActionButton(
                    icon: Icons.credit_card_outlined,
                    label: 'Details',
                    onTap: () {
                      if (controller.card.value != null) {
                        Get.toNamed(Routes.VIRTUAL_CARD_FULL_DETAILS,
                            arguments: {'cardModel': controller.card.value});
                      }
                    },
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
                  if (controller.card.value != null) {
                    Get.toNamed(Routes.VIRTUAL_CARD_TOP_UP,
                        arguments: {'cardId': controller.card.value!.id});
                  }
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
    String? brand,
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
              if (brand != null)
                TextBold(
                  brand.toUpperCase(),
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                )
              else
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
              Obx(() => TextBold(
                    controller.card.value?.status.toLowerCase() == 'inactive'
                        ? 'Unfreeze'
                        : 'Freeze',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  )),
              const Gap(16),
              Obx(() => TextSemiBold(
                    controller.card.value?.status.toLowerCase() == 'inactive'
                        ? 'Are you sure you want to unfreeze your Card?'
                        : 'Are you sure you want to freeze your Card?',
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.center,
                  )),
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
                        if (controller.card.value != null) {
                          if (controller.card.value!.status.toLowerCase() ==
                              'inactive') {
                            controller.unfreezeCard(controller.card.value!.id);
                          } else {
                            controller.freezeCard(controller.card.value!.id);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Obx(
                        () => controller.isFreezing.value ||
                                controller.isUnfreezing.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : TextBold(
                                'Yes',
                                fontSize: 16,
                                color: Colors.white,
                              ),
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

  // Keeping this for reference, though unused in current flow
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

  Color _getCardColor(String? brand) {
    if (brand == null) return Colors.blueGrey;
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1E3A8A); // Blue
      case 'mastercard':
        return const Color(0xFFEB001B); // Red-ish/Orange
      case 'verve':
        return AppColors.primaryGreen;
      default:
        return Colors.blueGrey;
    }
  }
}
