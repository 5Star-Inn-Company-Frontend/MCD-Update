import 'package:mcd/app/modules/home_screen_module/home_screen_controller.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../../core/import/imports.dart';
import '../../utils/bottom_navigation.dart';
import '../../widgets/app_bar.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeScreenPage extends GetView<HomeScreenController> {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while fetching dashboard
      if (controller.isLoading && controller.dashboardData == null) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        );
      }

      return Scaffold(
        appBar: PaylonyAppBar(
          title: "Hello ${controller.dashboardData?.user.userName ?? 'User'} 👋🏼",
          elevation: 0,
          actions: [
            TouchableOpacity(
                child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.QRCODE_MODULE);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/bx_scan.svg',
                      colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ))),
            const Gap(10),
            TouchableOpacity(
                child: InkWell(
                    onTap: () {
                      // Get.toNamed(
                      //   Routes.VIRTUAL_CARD_HOME,
                      //   arguments: {'cardIsAdded': false},
                      // );
                    },
                    child: SvgPicture.asset(AppAsset.profileIicon))),
            const Gap(10),
            TouchableOpacity(
                child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.NOTIFICATION_MODULE);
                    },
                    child: SvgPicture.asset(AppAsset.notificationIicon))),
            const Gap(12)
          ],
        ),
        body: RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: AppColors.white,
          onRefresh: controller.refreshDashboard,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.MORE_MODULE, arguments: {'initialTab': 1});
                      },
                      child: Container(
                        width: screenWidth(context) * 0.4,
                        padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryGrey2),
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextSemiBold(
                              controller.dashboardData?.user.referralPlan.isNotEmpty == true
                                  ? controller.dashboardData!.user.referralPlan.toUpperCase()
                                  : "FREE",
                              fontSize: 14,
                              color: AppColors.background.withOpacity(0.7),
                            ),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff1B1B1B)),
                      borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '₦ ',
                          style: const TextStyle(
                            color: AppColors.background,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: controller.dashboardData?.balance.wallet ?? '0',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.manRope,
                                  color: AppColors.background),
                            ),
                            const TextSpan(
                              text: '.00',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.manRope,
                                  color: AppColors.background),
                            ),
                          ],
                        ),
                        // textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        maxLines: 10,
                        textWidthBasis: TextWidthBasis.parent,
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: true,
                          applyHeightToLastDescent: true,
                        ),
                        key: const Key('myRichTextWidgetKey'),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.ADD_MONEY_MODULE,
                            arguments: {
                              'dashboardData': controller.dashboardData,
                            },
                          );
                        },
                        child: Row(
                          children: [
                            TextSemiBold(
                              "Add Money",
                              fontSize: 14,
                            ),
                            const Gap(8),
                            const Icon(Icons.arrow_forward_ios_outlined, color: AppColors.primaryGrey2,),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  // height: screenHeight(context) * 0.13,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 40),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      // border: Border.all(
                      //     width: 1, color: const Color(0xff1B1B1B)),
                      border: Border(
                        bottom: BorderSide(width: 1, color: AppColors.primaryGrey2,),
                        right: BorderSide(width: 1, color: AppColors.primaryGrey2,),
                        left: BorderSide(width: 1, color: AppColors.primaryGrey2,),
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dataItem("Commision", controller.dashboardData?.balance.commission ?? '0'),
                          dataItem("Points", controller.dashboardData?.balance.points ?? '0'),
                          dataItem("Bonus", controller.dashboardData?.balance.bonus ?? '0'),
                          dataItem("General Market", controller.dashboardData?.balance.wallet ?? '0')
                        ],
                      ),
                    ],
                  ),
                ),

                const Gap(15),
                // marquee
                SizedBox(
                  height: screenHeight(context) * 0.03,
                  child: Marquee(
                    text: controller.dashboardData?.news ?? 'Welcome to Mega Cheap Data',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: AppFonts.manRope),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 50.0,
                    velocity: 50.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
                const Divider(
                  color: AppColors.boxColor,
                ),

                const Gap(10),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: controller.actionButtonz.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return TouchableOpacity(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF3FFF7),
                                borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () async {
                                // Check service availability first
                                final isAvailable = await controller.handleServiceNavigation(controller.actionButtonz[index]);
                                
                                if (!isAvailable) {
                                  return; // Service not available, dialog already shown
                                }
                                
                                // Proceed with navigation if service is available
                                if (controller.actionButtonz[index].link == Routes.RESULT_CHECKER_MODULE) {
                                  _showResultCheckerOptions(context);
                                } else if (controller.actionButtonz[index].link == "epin") {
                                  _showEpinOptionsBottomSheet(context);
                                } else if (controller.actionButtonz[index].link == Routes.AIRTIME_MODULE ||
                                           controller.actionButtonz[index].link == Routes.DATA_MODULE) {
                                  Get.toNamed(
                                    Routes.NUMBER_VERIFICATION_MODULE,
                                    arguments: {'redirectTo': controller.actionButtonz[index].link}
                                  );
                                } else if (controller.actionButtonz[index].text == "Mega Bulk Service") {
                                  try {
                                    final url = Uri.parse('https://megabulk.5starcompany.com.ng/');
                                    await launcher.launchUrl(url);
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      "Could not open Mega Bulk Service",
                                      backgroundColor: AppColors.errorBgColor,
                                      colorText: AppColors.textSnackbarColor,
                                    );
                                  }
                                } else if (controller.actionButtonz[index].link.isNotEmpty) {
                                  Get.toNamed(controller.actionButtonz[index].link);
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      controller.actionButtonz[index].icon),
                                  const Gap(5),
                                  TextSemiBold(
                                    controller.actionButtonz[index].text,
                                    textAlign: TextAlign.center,
                                    color: AppColors.primaryColor,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }),
                const Divider(
                  color: AppColors.boxColor,
                ),
                const Gap(10),
                SizedBox(
                    width: double.infinity, child: Image.asset(AppAsset.banner))
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigation(selectedIndex: 0,),
      );
    });
  }

  void _showResultCheckerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final options = [
          {'title': 'Result Checker Token', 'type': 'token', 'route': Routes.RESULT_CHECKER_MODULE},
          {'title': 'JAMB Pin', 'type': 'jamb', 'route': Routes.JAMB_MODULE},
          {'title': 'Registration Pin', 'type': 'registration', 'route': Routes.RESULT_CHECKER_MODULE},
        ];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...options.map((option) => TouchableOpacity(
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(
                    option['route']!,
                    arguments: {'type': option['type']},
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option['title']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.background,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              )),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }

  void _showEpinOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final options = [
          {
            'title': 'Airtime Pin',
            'route': Routes.AIRTIME_PIN_MODULE,
          },
          {
            'title': 'Data Pin',
            'route': Routes.DATA_PIN,
          },
        ];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextSemiBold(
              //   'Select E-Pin Service',
              //   fontSize: 18,
              //   color: AppColors.primaryColor,
              // ),
              const Gap(20),
              ...options.map((option) => TouchableOpacity(
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(option['route']!);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['title']!,
                              style: const TextStyle(
                                fontFamily: AppFonts.manRope,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.background,
                      ),
                    ],
                  ),
                ),
              )),
              const Gap(40),
            ],
          ),
        );
      },
    );
  }

  Widget dataItem(String name, String amount) {
    return Column(
      children: [
        Text(
          amount,
          style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        const Gap(10),
        TextSemiBold(
          name,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        )
      ],
    );
  }
}
