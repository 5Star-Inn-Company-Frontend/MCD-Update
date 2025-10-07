import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
// import 'package:marquee/marquee.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/constants.dart';
import 'package:mcd/core/navigators/routes_name.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mcd/features/home/data/model/button_model.dart';
import 'package:mcd/features/home/presentation/views/notification_screen.dart';
import 'package:mcd/features/home/presentation/views/plan.dart';
import 'package:mcd/features/qrcode/qr_code_screen.dart';
import 'package:mcd/features/transaction/presentation/add_money.screen.dart';
import 'package:mcd/features/virtual_card/presentation/views/virt_card_home_screen.dart';
import 'package:text_marquee/text_marquee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  
  @override
  void initState() {
    super.initState();
    authController.fetchDashboard(); // only fetch if not cached
  }

  List<ButtonModel> actionButtonz = <ButtonModel>[
    ButtonModel(icon: AppAsset.airtime, text: "Airtime", link: "airtime"),
    ButtonModel(icon: AppAsset.internet, text: "Internet Data", link: "data"),
    ButtonModel(icon: AppAsset.tv, text: "Cable Tv", link: "cableTv"),
    ButtonModel(icon: AppAsset.electricity, text: "Electricity", link: Routes.electricity),
    ButtonModel(icon: AppAsset.ball, text: "Betting", link: "betting"),
    ButtonModel(icon: AppAsset.list, text: "Epins", link: "epin"),
    ButtonModel(icon: AppAsset.money, text: "Airtime to cash", link: Routes.airtime2cash),
    ButtonModel(icon: AppAsset.docSearch, text: "Reseult checker", link: "result_checker"),
    ButtonModel(icon: AppAsset.posIcon, text: "POS", link: Routes.pos),
    ButtonModel(icon: AppAsset.nin, text: "NIN Validation", link: "nin"),
    ButtonModel(icon: AppAsset.gift, text: "Reward Centre", link: "reward"),
    ButtonModel(icon: AppAsset.service, text: "Mega Bulk Service", link: "/airtime"),
  ];


  @override
  Widget build(BuildContext context) {
    final user = authController.dashboardData.value;

    return Scaffold(
      appBar: PaylonyAppBar(
        title: "Hello ${user?.user.userName} 👋🏼",
        elevation: 0,
        actions: [
          TouchableOpacity(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRCodeScreen()));
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VirtCardHomeScreen(cardIsAdded: false,)));
              },
              child: SvgPicture.asset(AppAsset.profileIicon))),
          const Gap(10),
          TouchableOpacity(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationScreen()));
                  },
                  child: SvgPicture.asset(AppAsset.notificationIicon))),
          const Gap(12)
        ],
      ),
      body: Padding(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PlanScreen(
                              isAppbar: true,
                            )));
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
                          "Bronze",
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff1B1B1B)),
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: '₦ ',
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: '123,349',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.manRope,
                              color: AppColors.background),
                        ),
                        TextSpan(
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddMoneyScreen()));
                    },
                    child: Row(
                      children: [
                        TextSemiBold(
                          "Add Money",
                          fontSize: 14,
                        ),
                        const Gap(8),
                        const Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            Container(
              width: double.infinity,
              height: screenHeight(context) * 0.16,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border.all(width: 1, color: const Color(0xff1B1B1B)),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dataItem("Commision", "${user?.balance.commission}"),
                      dataItem("Points", "${user?.balance.points}"),
                      dataItem("Bonus", "${user?.balance.bonus}"),
                      dataItem("General Market", "${user?.balance.wallet}")
                    ],
                  ),
                ],
              ),
            ),
            // const Gap(15),
            // SizedBox(
            //   height: screenHeight(context) * 0.03,
            //   child: Marquee(
            //     text:
            //         'Welcome to Mega Cheap Data . Welcome to Mega Cheap Data . Welcome to Mega Cheap Data . Welcome to Mega Cheap Data',
            //     style: const TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 14,
            //         fontFamily: AppFonts.manRope),
            //     scrollAxis: Axis.horizontal,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     blankSpace: 20.0,
            //     velocity: 100.0,
            //     pauseAfterRound: const Duration(seconds: 1),
            //     startPadding: 10.0,
            //     accelerationDuration: const Duration(seconds: 1),
            //     accelerationCurve: Curves.linear,
            //     decelerationDuration: const Duration(milliseconds: 500),
            //     decelerationCurve: Curves.easeOut,
            //   ),
            // ),
            
            const Gap(15),
            SizedBox(
              height: screenHeight(context) * 0.03,
              child: const TextMarquee(
                'Welcome to Mega Cheap Data . Welcome to Mega Cheap Data . Welcome to Mega Cheap Data . Welcome to Mega Cheap Data',
                spaceSize: 20,
                rtl: true,
                startPaddingSize: 10,
                curve: Curves.linearToEaseOut,
                duration: Duration(milliseconds: 1000),
                delay: Duration(seconds: 1),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: AppFonts.manRope),
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
                itemCount: actionButtonz.length,
                itemBuilder: (BuildContext ctx, index) {
                  return TouchableOpacity(
                      onTap: () {},
                      child: Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        // alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xffF3FFF7),
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () =>
                              context.goNamed(actionButtonz[index].link),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(actionButtonz[index].icon),
                              const Gap(5),
                              TextSemiBold(
                                actionButtonz[index].text,
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
