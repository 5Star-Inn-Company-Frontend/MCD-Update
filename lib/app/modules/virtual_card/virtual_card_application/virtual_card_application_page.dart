import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/fonts.dart';
import './virtual_card_application_controller.dart';

class VirtualCardApplicationPage
    extends GetView<VirtualCardApplicationController> {
  const VirtualCardApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Card Created",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        final card = controller.cardData.value;
        if (card == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),

              // success message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.successBgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.primaryGreen),
                    const Gap(12),
                    Expanded(
                      child: TextSemiBold(
                        'Your virtual card has been created successfully!',
                        fontSize: 14,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),

              // card details section
              TextBold(
                'Card Details',
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              const Gap(20),

              // name
              _buildDetailRow('Name', card.name),
              const Gap(16),

              // card number with visibility toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBold(
                    'Card Number',
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                  Row(
                    children: [
                      Obx(() => Text(
                            controller.displayCardNumber,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: AppFonts.manRope,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      const Gap(8),
                      GestureDetector(
                        onTap: controller.toggleNumberVisibility,
                        child: Obx(() => Icon(
                              controller.isNumberVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                              color: Colors.grey.shade600,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(16),

              // cvv
              _buildDetailRow('CVV', card.ccv),
              const Gap(16),

              // expiry
              _buildDetailRow('Expiry', card.expiry),
              const Gap(16),

              // currency
              _buildDetailRow('Currency', card.currency),
              const Gap(16),

              // brand
              _buildDetailRow('Brand', card.brand.toUpperCase()),
              const Gap(30),

              // fee and charges section
              TextBold(
                'Fee and Charges',
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              const Gap(20),

              // issuance fee
              _buildDetailRow('Issuance Fee', '${card.currencySymbol}2.00'),
              const Gap(16),

              // fee (changed from maintenance fee)
              _buildDetailRow('Fee', '${card.currencySymbol}0.50'),
              const Gap(40),

              // view my card button
              BusyButton(
                title: 'View My Card',
                onTap: () {
                  Get.offAllNamed(Routes.VIRTUAL_CARD_HOME);
                },
              ),
              const Gap(40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextBold(
          label,
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w800,
        ),
        Flexible(
          child: TextSemiBold(
            value,
            fontSize: 14,
            color: Colors.black,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
