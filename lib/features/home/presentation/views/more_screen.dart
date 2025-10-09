import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/features/auth/domain/repositories/auth_repository.dart';
import 'package:mcd/features/home/presentation/account_info_screen.dart';
import 'package:mcd/features/home/presentation/views/agent_request_screeen.dart';
import 'package:mcd/features/home/presentation/views/home_navigation.dart';
import 'package:mcd/features/home/presentation/views/plan.dart';
import 'package:mcd/features/home/presentation/views/settings_screen.dart';
import 'package:mcd/routes/app_routes.dart';

class MoreProfileScreen extends StatefulWidget {
  const MoreProfileScreen({super.key});

  @override
  State<MoreProfileScreen> createState() => _MoreProfileScreenState();
}

class _MoreProfileScreenState extends State<MoreProfileScreen> {
  final AuthRepository authRepository = Get.find<AuthRepository>(); 

  Future<void> logoutUser() async {
    await authRepository.logout();
    Get.offAllNamed(AppRoutes.login);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: TextBold(
              'More',
              fontSize: 20,
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),

            elevation: 0.0,
            centerTitle: false,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.primaryGrey, width: 1),
                          top: BorderSide(color: AppColors.primaryGrey))),
                  child: const TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorPadding: EdgeInsets.zero,
                      labelColor: AppColors.primaryGreen,
                      dividerHeight: 0,
                      indicatorColor: Colors.transparent,
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryGreen,
                      ),
                      padding: EdgeInsets.zero,
                      tabs: [
                        Text('General'),
                        Text('Subscriptions'),
                        Text('Referrals'),
                        Text('Support'),
                        Text('API'),
                      ]),
                )),
            // foregroundColor: AppColors.white,
          ),
          body: TabBarView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: ListView(
                shrinkWrap: true,
                children: [
                  rowcard('Account Information', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AccountInfoScreen()));
                  }, false),
                  rowcard('KYC Update', () {
                    Get.toNamed(AppRoutes.kycUpdate);
                  }, false),
                  rowcard('Agent Request', () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AgentRequestScreen()));
                  }, false),
                  rowcard('Transaction History', () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeNavigation(fixedIndex: 1,)));
                  }, false),
                  rowcard('Withdraw Bonus', () {}, false),
                  rowcard('Settings', () {
                     Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
                  }, false),
                  rowcard('Logout', () {logoutUser();}, true)
                ],
              ),
            ),
            PlanScreen(isAppbar:false),
            Container(),
            Container(),
            Container(),
          ])),
    );
  }

   Widget rowcard(String name, VoidCallback onTap, bool isLogout) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
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
                SvgPicture.asset(
                    isLogout == false ? AppAsset.arrowRight : AppAsset.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
