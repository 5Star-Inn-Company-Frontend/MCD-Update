import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';

class UploadHistoryScreen extends StatefulWidget {
  const UploadHistoryScreen({super.key});

  @override
  State<UploadHistoryScreen> createState() => _UploadHistoryScreenState();
}

class _UploadHistoryScreenState extends State<UploadHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Upload History', centerTitle: false,),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Gap(30),

              for (int i = 0; i < 15; i++)
              productUploadHistoryListTile()
            ]
          )
        )
      )
    );
  }


  Widget productUploadHistoryListTile() {
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

              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Column(
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
                      children: [
                        Text('Status', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                        Gap(10.w),
                        Text('Active', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                      ]
                    ),
                  ]
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}