import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/app_asset.dart';
import './add_money_module_controller.dart';

class AddMoneyModulePage extends GetView<AddMoneyModuleController> {
  const AddMoneyModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Fund Wallet",
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Obx(() {
            final user = controller.dashboardData.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold("Choose a method to receive money into your wallet"),
                const Gap(20),
                TextSemiBold(
                  "Bank Transfer",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                const Gap(20),
                
                // Primary Account
                _buildAccountCard(
                  context: context,
                  accountName: user?.user.fullName != null ? "MCD-${user!.user.fullName}" : "N/A",
                  bankName: user?.virtualAccounts.hasPrimary == true
                      ? user!.virtualAccounts.primaryBankName
                      : "No bank name found",
                  accountNumber: user?.virtualAccounts.hasPrimary == true
                      ? user!.virtualAccounts.primaryAccountNumber
                      : "No account number found",
                  onShare: () {
                    if (user?.virtualAccounts.hasPrimary == true) {
                      controller.shareAccountDetails(
                        user!.virtualAccounts.primaryAccountNumber,
                        user.virtualAccounts.primaryBankName,
                      );
                    }
                  },
                  onCopy: () {
                    if (user?.virtualAccounts.hasPrimary == true) {
                      controller.copyToClipboard(
                        user!.virtualAccounts.primaryAccountNumber,
                        "Primary Account Number",
                      );
                    }
                  },
                ),
                
                const Gap(10),
                
                // Secondary Account
                _buildAccountCard(
                  context: context,
                  accountName: user?.user.fullName != null ? "MCD-${user!.user.fullName}" : "N/A",
                  bankName: user?.virtualAccounts.hasSecondary == true
                      ? user!.virtualAccounts.secondaryBankName
                      : "No bank name found",
                  accountNumber: user?.virtualAccounts.hasSecondary == true
                      ? user!.virtualAccounts.secondaryAccountNumber
                      : "No account number found",
                  onShare: () {
                    if (user?.virtualAccounts.hasSecondary == true) {
                      controller.shareAccountDetails(
                        user!.virtualAccounts.secondaryAccountNumber,
                        user.virtualAccounts.secondaryBankName,
                      );
                    }
                  },
                  onCopy: () {
                    if (user?.virtualAccounts.hasSecondary == true) {
                      controller.copyToClipboard(
                        user!.virtualAccounts.secondaryAccountNumber,
                        "Secondary Account Number",
                      );
                    }
                  },
                ),
                
                const Gap(20),
                
                // Other Funding Options
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffF0F0F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: controller.navigateToCardTopUp,
                        child: _buildFundingOption(
                          context: context,
                          icon: AppAsset.card,
                          title: 'Top-up with Card',
                          subtitle: "Add money directly from your bank card",
                        ),
                      ),
                      const Gap(10),
                      const Divider(color: Color(0xffF0F0F0)),
                      const Gap(10),
                      InkWell(
                        onTap: controller.navigateToUssd,
                        child: _buildFundingOption(
                          context: context,
                          icon: AppAsset.ussd,
                          title: 'USSD',
                          subtitle: "Add money to your wallet using ussd on your phone",
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAccountCard({
    required BuildContext context,
    required String accountName,
    required String bankName,
    required String accountNumber,
    required VoidCallback onShare,
    required VoidCallback onCopy,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF3FFF7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextSemiBold(
                accountName,
                fontSize: 15,
              ),
              InkWell(
                onTap: onShare,
                child: Row(
                  children: [
                    TextSemiBold("Share"),
                    const Gap(2),
                    SvgPicture.asset(AppAsset.share)
                  ],
                ),
              )
            ],
          ),
          const Gap(30),
          TextSemiBold(bankName),
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextSemiBold(
                  accountNumber,
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: onCopy,
                child: Row(
                  children: [
                    TextSemiBold(
                      "Copy",
                      color: AppColors.primaryColor,
                    ),
                    const Gap(5),
                    const Icon(
                      Icons.copy,
                      color: AppColors.primaryColor,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFundingOption({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(icon),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSemiBold(title),
                    const Gap(5),
                    TextSemiBold(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
        )
      ],
    );
  }
}