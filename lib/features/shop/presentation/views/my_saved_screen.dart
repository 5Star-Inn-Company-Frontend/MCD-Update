import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class MySavedScreen extends StatefulWidget {
  const MySavedScreen({super.key});

  @override
  State<MySavedScreen> createState() => _MySavedScreenState();
}

class _MySavedScreenState extends State<MySavedScreen> {
  bool savedIsEMpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      drawer: const ShopDrawer(),
      body: CustomSingleChildScrollView(
        child: Column(
        children: [
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Saved', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(90, 187, 123, 1)))
              ]
            )
          ),

          const Gap(10),

          savedIsEMpty == false
          ? savedListEmptyWidget()
          : savedItemWidget()
             

        ]
      )
    ));
  }

  Widget savedItemWidget() {
    return SizedBox(
      height: screenHeight(context) * 0.75,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight(context) * 0.15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/high-heel.png', fit: BoxFit.cover,),
                    const Gap(10),
                
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pull and deer', style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black)),
                                Text('Fancy', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1))),
                                const Gap(10),
                                Text('# 234.90', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(90, 187, 123, 1))),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     SvgPicture.asset('assets/icons/delete-cart-item.svg'),
                            //   ],
                            // ),
                          ],
                        ),
                
                        BusyButton(title: 'ADD TO BAG', onTap: () {}, width: screenWidth(context) * 0.65,)
                      ],
                    ),
                  ],
                ),
              ),
              const Divider()
            ],
          ),
        );
      })
    );
  }

  Widget savedListEmptyWidget() {
    return Column(
      children: [
        const Gap(50),
        const Icon(Icons.favorite_border, color: Colors.grey, size: 100),
        const Gap(10),
        Text('Your saved list is empty', style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(71, 71, 71, 1))),
        const Gap(20),
        BusyButton(title: 'SHOP NOW', onTap: () {}, borderRadius: BorderRadius.circular(5), width: screenWidth(context) * 0.35,)
      ],
    );
  }
}