import 'package:mcd/core/import/imports.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/app/modules/plans_module/plans_module_page.dart';

import './more_module_controller.dart';

class MoreModulePage extends GetView<MoreModuleController> {
  const MoreModulePage({super.key});

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
                  rowcard('Account Information', () {Get.toNamed(Routes.ACCOUNT_INFO);}, false),
                  rowcard('KYC Update', () {
                    // Get.toNamed(AppRoutes.kycUpdate);
                  }, false),
                  rowcard('Agent Request', () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const AgentRequestScreen()));
                  }, false),
                  rowcard('Transaction History', () {
                    Get.offAllNamed(Routes.HISTORY_SCREEN);
                  }, false),
                  rowcard('Withdraw Bonus', () {}, false),
                  rowcard('Settings', () {
                    Get.toNamed(Routes.SETTINGS_SCREEN);
                  }, false),
                  rowcard('Logout', () {
                    if (Get.isRegistered<MoreModuleController>()) {
                      controller.logoutUser();
                    } else {
                      Get.put(MoreModuleController()).logoutUser();
                    }
                    }, true)
                ],
              ),
            ),
            const PlansModulePage(isAppbar: false),
            _buildReferralsTab(),
            Container(),
            Container()
          ]),
          bottomNavigationBar: const BottomNavigation(selectedIndex: 4)),
    );
  }

  Widget _buildReferralsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          SizedBox(
            width: double.infinity,
            height: 300,
            child: SvgPicture.asset(
              'assets/icons/referral_banner.svg',
              fit: BoxFit.cover,
            ),
          ),
          const Gap(24),
          
          TextSemiBold(
            'Invite your friends and earn',
            fontSize: 16,
            // color: AppColors.primaryGrey,
          ),
          const Gap(24),
          
          // App Referral Card
          _buildReferralCard(
            icon: 'assets/icons/app_referral.svg',
            title: 'App Referral',
            description: 'Get FREE 250MB instantly, when you refer a friend to download Mega Cheap Data App. While your friends gts 1GB data bonus.',
            // iconColor: const Color(0xFF4CAF50),
          ),
          const Gap(16),
          
          // Data Referral Card
          _buildReferralCard(
            icon: 'assets/icons/data_referral.svg',
            title: 'Data Referral',
            description: 'Get FREE 250MB instantly, when you refer a friend to download Mega Cheap Data App. While your friends gts 1GB data bonus.',
            // iconColor: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCard({
    required String icon,
    required String title,
    required String description,
    // required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          SvgPicture.asset(
            icon,
            // colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          const Gap(12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 15,
                  children: [
                    TextSemiBold(
                      title,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      // color: AppColors.primaryGrey,
                    ),
                  ],
                ),
                const Gap(8),
                TextSemiBold(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    // color: AppColors.primaryGrey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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