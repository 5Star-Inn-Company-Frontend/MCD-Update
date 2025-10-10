import 'package:mcd/core/import/imports.dart';
import './account_info_module_controller.dart';

class AccountInfoModulePage extends GetView<AccountInfoModuleController> {
    
  const AccountInfoModulePage({super.key});

  @override
  Widget build(BuildContext context) {

    Widget columnText(String amount, String text) {
      return Column(
        children: [
          TextSemiBold(
            amount,
            fontSize: 13,
          ),
          const Gap(4),
          TextSemiBold(
            text,
            fontSize: 11,
          ),
        ],
      );
    }

    Widget rowText(String text, String subtext) {
      return Row(
        children: [
          TextSemiBold(
            text,
            fontSize: 14,
          ),
          const Spacer(),
          TextSemiBold(
            subtext,
            fontSize: 14,
          ),
          const Gap(5),
          const Icon(Icons.more_horiz_outlined)
        ],
      );
    }

    Widget rowcard(String name, VoidCallback onTap, bool isText, String? subText) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TouchableOpacity(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGrey, width: 0.5),
                color: AppColors.white,
                borderRadius: BorderRadius.circular(3)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  TextSemiBold(name),
                  const Spacer(),
                  isText == false
                      ? SvgPicture.asset(AppAsset.arrowRight)
                      : TextSemiBold(subText!),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "My Profile",
        // elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                const Gap(20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        color: AppColors.background.withOpacity(0.1),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          children: [
                            Container(
                              // height: 54,
                              // width: 54,
                              decoration: BoxDecoration(
                                  color: AppColors.lightGreen,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: controller.user?.user.photo == '' ? Image.asset("${controller.user?.user.photo}") : SvgPicture.asset(AppAsset.camera),
                              ),
                            ),
                            const Gap(10),
                            TextSemiBold(
                              "${controller.user?.user.fullName}",
                              fontSize: 16,
                            ),
                            const Gap(6),
                            TextSemiBold(
                              '@"${controller.user?.user.userName}"',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: AppColors.filledBorderIColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            columnText('₦0', 'Total Funding'),
                            columnText('₦0', 'Total Transaction'),
                            columnText('0', 'Total Referral'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 0),
                        color: AppColors.background.withOpacity(0.1),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        rowText('Name', "${controller.user?.user.fullName}"),
                        const Gap(20),
                        rowText('Email', "${controller.user?.user.email}"),
                        const Gap(20),
                        rowText('Phone', "${controller.user?.user.phoneNo}"),
                        const Gap(20),
                        rowText('Username', "${controller.user?.user.userName}"),
                      ],
                    ),
                  ),
                ),
                 const Gap(20),
                 rowcard('Plan (Free)', () { }, false, ''),
                 rowcard('Target', () { }, true, '(Level ${controller.user?.user.level})'),
                 rowcard('General Market', () { }, false, ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}