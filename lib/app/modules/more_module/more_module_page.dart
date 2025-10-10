import 'package:mcd/core/import/imports.dart';

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