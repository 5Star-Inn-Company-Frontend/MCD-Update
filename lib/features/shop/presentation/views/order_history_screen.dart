import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/views/order_history_tabs/done_tab.dart';
import 'package:mcd/features/shop/presentation/widgets/camera/camera_option_dialog.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: searchAppBar(),),
          centerTitle: false,
          titleSpacing: 0.0,
          actions: [
            GestureDetector(onTap: () {CameraOptionDialog;}, child: SvgPicture.asset('assets/icons/camera.svg')),
            SizedBox(width: screenWidth(context) * 0.03,)
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order History', style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)))
                    ]
                  ),
                ),
                const Gap(5),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    splashBorderRadius: BorderRadius.circular(10),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorPadding: EdgeInsets.zero,
                    labelColor: AppColors.primaryGreen,
                    dividerHeight: 0,
                    indicatorColor: Colors.transparent,
                    labelStyle: GoogleFonts.poppins(fontSize: 11.sp, color: AppColors.primaryGreen,),
                    padding: EdgeInsets.zero,
                    tabs: const [
                      Text('Not yet payed'),
                      Text('Packed'),
                      Text('Done'),
                      Text('Cancel'),
                      Text('Return'),
                    ]
                  ),
                ),
              ],
            )
          ),
        ),
        drawer: const ShopDrawer(),
        body: TabBarView(
          children: [
            SafeArea(
              child: SingleChildScrollView(
               child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Column(
                    children: [
                      const Gap(20),
                      Text('Order History', style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)))
                    ]
                  )
                )
              )
            ),
            Container(),
            const DoneTab(),
            Container(),
            Container(),
          ],
        )
      ),
    );
  }

  Widget searchAppBar() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              'assets/icons/circle-three-dots.svg',
            ),
            onPressed: () => Scaffold.of(context).openDrawer()
          ),
          
        ),
        // const Gap(10),
        SizedBox(
          height: screenHeight(context) * 0.05,
          width: screenWidth(context) * 0.78,
          child: TextField(
            cursorColor: Colors.black,
            style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w400, color: Colors.black),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 10),
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search what you need',
              hintStyle: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(192, 192, 192, 1)),
              filled: true,
              fillColor: const Color.fromRGBO(238, 238, 238, 1),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ),
      ],
    );
  }

  // 
}