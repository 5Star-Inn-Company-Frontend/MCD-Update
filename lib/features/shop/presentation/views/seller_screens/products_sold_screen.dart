import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';

class ProductsSoldScreen extends StatefulWidget {
  const ProductsSoldScreen({super.key});

  @override
  State<ProductsSoldScreen> createState() => _ProductsSoldScreenState();
}

class _ProductsSoldScreenState extends State<ProductsSoldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Products Sold', centerTitle: false),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Gap(30),

              Container(
                height: 70.h,
                margin: EdgeInsets.only(bottom: 20.h),
                child: Row(
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Price Sold', style: GoogleFonts.poppins(fontSize: 12.78.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
                            
                            Gap(10.w),
                            
                            Text('# 398.90', style: GoogleFonts.poppins(fontSize: 12.78.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 160, 88, 1))
                            )
                          ]
                        ),
                      ]
                    ),
                  ]
                ),
              )
            ]
          )
        )
      )
    );
  }
}