import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';

import '../../core/constants/app_asset.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/ui_helpers.dart';
import '../../routes/app_routes.dart';
import '../styles/app_colors.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  const BottomNavigation({Key? key, required this.selectedIndex}) : super(key: key);

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOME_SCREEN);
        break;
      case 1:
        Get.toNamed(Routes.HISTORY_SCREEN);
        break;
      case 2:
        Get.toNamed(Routes.SHOP_SCREEN);
        break;
      case 3:
        Get.toNamed(Routes.ASSISTANT_SCREEN);
        break;
      case 4:
        Get.toNamed(Routes.MORE_MODULE);
        break;
      default:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: BottomNavigationBar(
          iconSize: 60,
          type: BottomNavigationBarType.fixed,
          elevation: 30,
          selectedItemColor: AppColors.primaryColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: selectedIndex,
          enableFeedback: true,
          selectedLabelStyle: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12,
              fontFamily: AppFonts.manRope,
              fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(
              color: AppColors.textPrimaryColor2,
              fontSize: 12,
              fontFamily: AppFonts.manRope,
              fontWeight: FontWeight.w500),
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAsset.systemIcon,
                width: screenWidth(context) * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                AppAsset.systemActiveIcon,
                width: screenWidth(context) * 0.06,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAsset.historyIcon,
                width: screenWidth(context) * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                AppAsset.historyActiveIcon,
                width: screenWidth(context) * 0.06,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/shop-inactive.svg',
                width: screenWidth(context) * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/shop-active.svg',
                width: screenWidth(context) * 0.06,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAsset.assistantIcon,
                width: screenWidth(context) * 0.06,
              ),
              activeIcon: SvgPicture.asset(AppAsset.assistantActiveIcon),
              label: 'Assistant',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AppAsset.moreIcon,
                width: screenWidth(context) * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                AppAsset.moreActiveIcon,
                width: screenWidth(context) * 0.06,
              ),
              label: 'More',
            ),
          ],
        ));
  }
}
