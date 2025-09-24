import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_dialog.dart';

class ProductsPendingScreen extends StatefulWidget {
  const ProductsPendingScreen({super.key});

  @override
  State<ProductsPendingScreen> createState() => _ProductsPendingScreenState();
}

class _ProductsPendingScreenState extends State<ProductsPendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Pending', centerTitle: false),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Gap(30),

              for (int i = 0; i < 15; i++)
              productPendingListTile(),
            ]
          )
        )
      )
    );
  }

  Widget productPendingListTile() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/shop-woman.png', fit: BoxFit.fill, height: 70.h, width: 90.w),

              const Gap(10),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Donatello', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
                      Text('24 Dec 2023', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1))),
                    ],
                  ),

                  Text('Pending', style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(255, 170, 0, 1))),
                ]
              )
            ]
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₦ 398.00', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),

              Row(
                children: [
                  Text('Edit', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(90, 187, 123, 1))),
                  Gap(10.w),

                  GestureDetector(
                    onTap: () {
                      print('Edit');
                      const ProductsDialog(
                      body: 'This goods will be remove from pending list and it wont be available at the market'
                    );
                    },
                    child: Text('Remove', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(235, 0, 27, 1)))),
                  Gap(10.w),
                ],
              )
            ]
          )
        ]
      )
    );
  }
}