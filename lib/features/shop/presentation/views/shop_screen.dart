import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/features/shop/models/item_model.dart';
import 'package:mcd/features/shop/presentation/views/discount-shop.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isFavorite = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      drawer: const ShopDrawer(),
      body: CustomSingleChildScrollView(
        child: Column(
        children: [
          Gap(10.h),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(width: double.infinity, child: Image.asset('assets/images/shop-discount-ad.png', fit: BoxFit.fitWidth),),
          ),
          
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Discount ends in',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                    const Gap(20),
                    discountTimer()
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DiscountShopScreen()));
                  },
                  child: Text('See all',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(51, 160, 88, 1),
                    )
                  )
                ),
              ],
            ),
          ),

          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, index) {
                return productContainer();
              }),
          ),

          Gap(20.h),
          
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming promotion', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black,)),
                
                Text('See all',style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 160, 88, 1),)),
              ],
            ),
          ),

          Gap(10.h),

          SizedBox(
            height: 50.h,
            child: ListView(
              padding: const EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(child: Image.asset('assets/images/shop-promo-1.png', fit: BoxFit.fitWidth),),
                const Gap(10),
                SizedBox(child: Image.asset('assets/images/shop-promo-2.png', fit: BoxFit.fitWidth)),
                const Gap(10),
                SizedBox(child: Image.asset('assets/images/shop-promo-1.png', fit: BoxFit.fitWidth)),
              ],
            ),
          ),

          Gap(20.h),

          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New in Shoes', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black,)),
                Text('See all', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 160, 88, 1),)),
              ],
            ),
          ),

          Gap(10.h),
          
          SizedBox(
            height: 130.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shoeItemsList.length,
                itemBuilder: (BuildContext context, index) {
                  return shoeProductContainer(shoeItemsList[index]);
                }),
          ),

          Gap(20.h),

          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New in Shirts', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black,)),
                
                Text('See all', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 160, 88, 1),)),
              ],
            ),
          ),

          Gap(10.h),

          SizedBox(
            height: 130.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, index) {
                return shoeProductContainer(shirtItemsList[index]);
              }
            ),
          ),

          const Gap(20),
        ],
      )),
    );
  }



  Widget productContainer() {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(left: 15.w),
      padding: EdgeInsets.only(left: 10.w, right: 10.w,),
      child: Column(
        children: [
          Image.asset('assets/images/high-heel.png'),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hermes', style: GoogleFonts.poppins(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.black),),

                  
                  Text('Antelope', style: GoogleFonts.poppins(fontSize: 11.sp,fontWeight: FontWeight.w400,color: const Color.fromRGBO(164, 164, 164, 1),)),
                  const Gap(5),
                  
                  Text('# 400.00', style: GoogleFonts.poppins(fontSize: 12.sp,fontWeight: FontWeight.w400,color: const Color.fromRGBO(51, 160, 88, 1),)),
                  
                  Text('# 400.00', style: GoogleFonts.poppins(fontSize: 9.sp,fontWeight: FontWeight.w400,color: const Color.fromRGBO(119, 119, 119, 1),))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFavorite = true;
                      });
                    },
                    child: Icon(
                        isFavorite ? Icons.favorite_border : Icons.favorite,
                        color: const Color.fromRGBO(51, 160, 88, 1)),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget shoeProductContainer(Item item) {
    return Container(
      width: 120.w,
      margin: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          SizedBox(
            height: 80.h,
            width: 120.w,
            child: FittedBox(fit: BoxFit.fill, child: Image.asset(item.image,),)
          ),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: GoogleFonts.poppins(fontSize: 12.sp,fontWeight: FontWeight.w400, color: Colors.black),),
                  Text(item.name, style: GoogleFonts.poppins(fontSize: 11.sp,fontWeight: FontWeight.w400, color: const Color.fromRGBO(164, 164, 164, 1),)),
                  const Gap(5),
                  Text('# 400.00',style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 160, 88, 1),)),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.favorite_border,color: Color.fromRGBO(51, 160, 88, 1))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget discountTimer() {
    return Row(
      children: [
        Container(
          height: screenHeight(context) * 0.032,
          width: screenHeight(context) * 0.032,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(51, 160, 88, 1),
              borderRadius: BorderRadius.circular(3)),
          child: Center(
            child: Text('02',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
          ),
        ),
        const Gap(5),
        Text(':',
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(51, 160, 88, 1),
            )),
        const Gap(5),
        Container(
          height: screenHeight(context) * 0.032,
          width: screenHeight(context) * 0.032,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(51, 160, 88, 1),
              borderRadius: BorderRadius.circular(3)),
          child: Center(
            child: Text('24',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
          ),
        ),
        const Gap(5),
        Text(':',
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(51, 160, 88, 1),
            )),
        const Gap(5),
        Container(
          height: screenHeight(context) * 0.032,
          width: screenHeight(context) * 0.032,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(51, 160, 88, 1),
              borderRadius: BorderRadius.circular(3)),
          child: Center(
            child: Text('09',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  
}
