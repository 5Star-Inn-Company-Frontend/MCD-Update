import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_decline_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_inreview_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_pending_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_return_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_sold_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/products_uploaded_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/upload_market_screen.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      drawer: const ShopDrawer(),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const Gap(30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Products', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black)),
                ]
              ),
          
              const Gap(10),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsUploadedScreen()));
                    },
                    child: cardWidget('556', 'Products Uploaded')),
          
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsSoldScreen()));
                    },
                    child: cardWidget('386', 'Products Sold')),
          
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsReturnScreen()));
                    },
                    child: cardWidget('70', 'Products Return')),
                ],
              ),
          
              const Gap(30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Uploading', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black)),
                ]
              ),
          
              const Gap(10),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsInreviewScreen()));
                    },
                    child: cardWidget('10', 'In-review'),),
          
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsPendingScreen()));
                    },
                    child: cardWidget('6', 'Pending'),),
          
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsDeclineScreen()));
                    },
                    child: cardWidget('23', 'Decline'),)
                ],
              ),
          
              const Gap(30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Goods', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black)),
                ]
              ),
          
              const Gap(10),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadMarketScreen()));
                    },
                    child: cardWidget('', 'Upload Market')),
          
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsInreviewScreen()));
                    },
                    child: cardWidget('', 'Upload History'),),
          
                  cardWidget('10', 'Goods Request'),
                ],
              ),
          ]
                ),
        )
    ));
  }


  Widget cardWidget(String cardNumber, String cardName) {
    return Container(
      width: screenWidth(context) * 0.25,
      height: screenHeight(context) * 0.125,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(242, 255, 247, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(cardNumber, style: GoogleFonts.manrope(fontSize: 24.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 160, 88, 1))),
          Text(cardName, style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 160, 88, 1))),
        ],
      ),
    );
  }
}