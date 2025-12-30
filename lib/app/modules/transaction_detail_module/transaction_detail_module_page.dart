import 'package:flutter/services.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:mcd/core/utils/functions.dart';
import 'package:google_fonts/google_fonts.dart';
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
          RepaintBoundary(
            key: controller.receiptKey,
            child: Container(
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
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "₦",
                                style: GoogleFonts.roboto(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: Functions.money(controller.amount, "").trim(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: AppFonts.manRope,
                                ),
                              ),
                            ],
                          ),
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
                if (controller.paymentType == "Electricity" && controller.token != 'N/A' && controller.token.isNotEmpty)
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
                                    snackPosition: SnackPosition.TOP,
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
                        itemRow("Payment Method", _formatPaymentMethod(controller.paymentMethod)),
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
                        itemRow("Posted date:", controller.date),
                        itemRow("Transaction date:", controller.date),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
          Obx(() => controller.isSharing
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  child: BusyButton(
                    title: "Share Receipt",
                    onTap: () => controller.shareReceipt(),
                  ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => controller.isDownloading
                    ? const Padding(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : actionButtons(
                        () => controller.downloadReceipt(),
                        SvgPicture.asset(AppAsset.downloadIcon),
                        "Download")),
                Obx(() => controller.isRepeating
                    ? const Padding(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : actionButtons(
                        () => controller.repeatTransaction(),
                        SvgPicture.asset(AppAsset.redoIcon),
                        "Buy Again")),
                actionButtons(() {}, SvgPicture.asset(AppAsset.rotateIcon),
                    "Add to recurring"),
                actionButtons(
                    () async {
                      try {
                        final authController = Get.find<LoginScreenController>();
                        final username = authController.dashboardData?.user.userName ?? 'User';
                        String mail = "mailto:info@5starcompany.com.ng?subject=Support Needed by $username";
                        await launcher.launchUrl(Uri.parse(mail));
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Could not open email client',
                          backgroundColor: AppColors.errorBgColor,
                          colorText: AppColors.textSnackbarColor,
                          snackPosition: SnackPosition.TOP,
                        );
                      }
                    },
                    SvgPicture.asset(AppAsset.helpIcon),
                    "Support"),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper widgets can remain in the view file
  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'wallet':
        return 'MCD Wallet';
      case 'paystack':
        return 'Paystack';
      case 'general_market':
        return 'General Market';
      case 'mega_bonus':
        return 'Mega Bonus';
      case 'bank':
        return 'Bank';
      default:
        return method;
    }
  }

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