import 'package:mcd/app/modules/airtime_module/airtime_module_controller.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/utils/functions.dart';
import './transaction_detail_module_controller.dart';

class TransactionDetailModulePage
    extends GetView<TransactionDetailModuleController> {
  TransactionDetailModulePage({super.key});

  final airtimeController = Get.find<AirtimeModuleController>();

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
                // The rest of your UI remains the same
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        itemRow("User ID", "012345678"),
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
                        itemRow("Transaction ID:", "012345678912345678"),
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