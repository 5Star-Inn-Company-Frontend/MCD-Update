import 'package:flutter/services.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/utils/functions.dart';
import './transaction_detail_module_controller.dart';

class TransactionDetailModulePage
    extends GetView<TransactionDetailModuleController> {
  const TransactionDetailModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: "Transaction Detail",
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAsset.spiralBg), fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage(controller.image),
                          width: 50,
                          height: 50,
                        ),
                        const Gap(8),
                        TextSemiBold(
                          controller.name,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        const Gap(6),
                        TextSemiBold(
                          Functions.money(controller.amount, "N"),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_outlined,
                              color: AppColors.primaryColor,
                            ),
                            const Gap(4),
                            TextSemiBold(
                              "Successful",
                              color: AppColors.primaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                
                // Show token for electricity payments
                if (controller.paymentType == "Electricity" && controller.token != 'N/A')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSemiBold("Token"),
                      const Gap(4),
                      Material(
                        elevation: 2,
                        color: AppColors.white,
                        shadowColor: const Color(0xff000000).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.token,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(text: controller.token));
                                  Get.snackbar(
                                    "Copied", 
                                    "Token copied to clipboard",
                                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                    colorText: AppColors.primaryColor,
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                    margin: const EdgeInsets.all(10),
                                    icon: const Icon(Icons.check_circle, color: AppColors.primaryColor),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextSemiBold("Copy", color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(8),
                    ],
                  ),
                
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        itemRow("User ID", controller.userId),
                        if (controller.paymentType == "Cable TV") ...[
                          itemRow("Customer Name", controller.customerName),
                          itemRow("Package", controller.packageName),
                        ],
                        if (controller.paymentType == "Electricity") ...[
                          itemRow("Customer Name", controller.customerName),
                          itemRow("Meter Type", controller.packageName),
                        ],
                        if (controller.paymentType == "NIN Validation") ...[
                          itemRow("NIN Number", controller.userId),
                          itemRow("Service Type", controller.packageName),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, color: AppColors.primaryColor, size: 16),
                                const Gap(8),
                                Expanded(
                                  child: Text(
                                    "Response will be available within 24 hours",
                                    style: TextStyle(fontSize: 13, color: AppColors.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        itemRow("Payment Type", controller.paymentType),
                        itemRow("Payment Method", "MCD balance"),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        itemRow("Transaction ID:", controller.transactionId),
                        itemRow("Posted date:", "22:57, Jan 21, 2024"),
                        itemRow("Transaction date:", "22:58, Jan 21, 2024"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: BusyButton(title: "Share Receipt", onTap: () {}),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                actionButtons(
                    () {}, SvgPicture.asset(AppAsset.downloadIcon), "Download"),
                actionButtons(
                    () {}, SvgPicture.asset(AppAsset.redoIcon), "Buy Again"),
                actionButtons(() {}, SvgPicture.asset(AppAsset.rotateIcon),
                    "Add to recurring"),
                actionButtons(
                    () {}, SvgPicture.asset(AppAsset.helpIcon), "Support"),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper widgets can remain in the view file
  Widget itemRow(String name, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Added horizontal margin
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(name, fontSize: 15, fontWeight: FontWeight.w500),
          TextSemiBold(value, fontSize: 15, fontWeight: FontWeight.w500)
        ],
      ),
    );
  }

  Widget actionButtons(VoidCallback onTap, Widget item, String name) {
    return Column(
      children: [
        InkWell( // Added InkWell for tap effect
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15), // Used all for uniform padding
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(5)),
            child: item,
          ),
        ),
        const Gap(5),
        TextSemiBold(name, fontSize: 13, fontWeight: FontWeight.w600)
      ],
    );
  }
}