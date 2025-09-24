import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_dialog.dart';

class ProductsReturnScreen extends StatefulWidget {
  const ProductsReturnScreen({super.key});

  @override
  State<ProductsReturnScreen> createState() => _ProductsReturnScreenState();
}

class _ProductsReturnScreenState extends State<ProductsReturnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Products Return', centerTitle: false),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Gap(30),

              for (int i = 0; i <= 10; i++)
              productReturnListTile()
            ]
          )
        )
      )
    );
  }

  Widget productReturnListTile() {
    return Container(
      height: 70.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Image.asset('assets/images/shop-woman.png', fit: BoxFit.fill, height: 70.h, width: 90.w),
      
          const Gap(10),
      
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Donatello', overflow: TextOverflow.ellipsis, maxLines: 1, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
                      Text('24 Dec 2023', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1))),
                    ],
                  ),
      
                  Text('₦ 398.00', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
                ],
              ),
      
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reason', style: GoogleFonts.poppins(fontSize: 12.78.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(22, 22, 22, 1))),
      
                  Text(
                    'This goods is not working perfectly, is having creak at the edges, the charges is not also working at all.', 
                    style: GoogleFonts.poppins(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1))
                  ),
                ],
              ),
      
              Row(
                children: [
                  BusyButton(
                    title: 'Decline',
                    onTap: () {},
                    color: const Color.fromRGBO(90, 187, 123, 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
      
                  BusyButton(
                    title: 'Accept',
                    onTap: () {
                      const ProductsDialog(
                        body: 'Clicking on Yes you will accept the return from the costumer and money will be return to the costumer'
                      );
                    },
                    color: const Color.fromRGBO(235, 0, 27, 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}