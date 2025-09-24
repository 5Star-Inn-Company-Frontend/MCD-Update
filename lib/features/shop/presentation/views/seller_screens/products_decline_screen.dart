import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';

class ProductsDeclineScreen extends StatefulWidget {
  const ProductsDeclineScreen({super.key});

  @override
  State<ProductsDeclineScreen> createState() => _ProductsDeclineScreenState();
}

class _ProductsDeclineScreenState extends State<ProductsDeclineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Decline', centerTitle: false),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Gap(30),

              for (int i = 0; i <= 10; i++)
              productDeclineTile()
            ]
          )
        )
      )
    );
  }

  Widget productDeclineTile() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Image.asset('assets/images/shop-woman.png', fit: BoxFit.fill, height: 70.h, width: 90.w),
      
          Gap(10.h),
      
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Donatello', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
                  Text('24 Dec 2023', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1))),
                ],
              ),

              Gap(10.h),
      
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reason', style: GoogleFonts.poppins(fontSize: 12.78.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
      
                  Text(
                    'This goods is not working perfectly, is having creak at the edges, the charges is not also working at all.', 
                    maxLines: 3, style: GoogleFonts.poppins(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1))
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}