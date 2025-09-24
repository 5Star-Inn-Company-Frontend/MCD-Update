import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:mcd/app/styles/app_colors.dart";
import "package:mcd/core/constants/app_asset.dart";
import "package:mcd/core/constants/fonts.dart";
import "package:mcd/core/utils/ui_helpers.dart";
import "package:mcd/features/home/presentation/views/assistant_screen.dart";
import "package:mcd/features/home/presentation/views/history_screen.dart";
import "package:mcd/features/home/presentation/views/home_screen.dart";
import "package:mcd/features/home/presentation/views/more_screen.dart";
import "package:mcd/features/shop/presentation/views/shop_screen.dart";
class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key, this.fixedIndex});

  final int? fixedIndex;

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    if (widget.fixedIndex!= null) {
      _selectedIndex = widget.fixedIndex!.toInt();
      _onItemTapped(_selectedIndex);
    }else{
      _onItemTapped(_selectedIndex);
    }

  }

  @override
  void dispose() {
    if (mounted) {
      _onItemTapped(_selectedIndex);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeScreen(),
      const HistoryScreen(),
      const ShopScreen(),
      const AssistantScreen(),
      const MoreProfileScreen()
    ];
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: SizedBox(
       
        child: BottomNavigationBar(
          iconSize: 60,
          type: BottomNavigationBarType.fixed,
          elevation: 30,
          selectedItemColor: AppColors.primaryColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _selectedIndex,
          enableFeedback: true,
          selectedLabelStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 12,
            fontFamily: AppFonts.manRope,
            fontWeight: FontWeight.w500
          ),
          unselectedLabelStyle: const TextStyle(
            color: AppColors.textPrimaryColor2,
            fontSize: 12,
            fontFamily: AppFonts.manRope,
            fontWeight: FontWeight.w500
          ),
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.systemIcon, width: screenWidth(context) * 0.06,),
              activeIcon: SvgPicture.asset(AppAsset.systemActiveIcon, width: screenWidth(context) * 0.06,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.historyIcon, width: screenWidth(context) * 0.06,),
              activeIcon: SvgPicture.asset(AppAsset.historyActiveIcon, width: screenWidth(context) * 0.06,),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/shop-inactive.svg', width: screenWidth(context) * 0.06,),
              activeIcon: SvgPicture.asset('assets/icons/shop-active.svg', width: screenWidth(context) * 0.06,),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.assistantIcon, width: screenWidth(context) * 0.06,),
              activeIcon: SvgPicture.asset(AppAsset.assistantActiveIcon),
              label: 'Assistant',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppAsset.moreIcon, width: screenWidth(context) * 0.06,),
              activeIcon: SvgPicture.asset(AppAsset.moreActiveIcon, width: screenWidth(context) * 0.06,),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}