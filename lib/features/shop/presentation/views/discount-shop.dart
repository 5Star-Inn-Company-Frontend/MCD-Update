import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/views/mybag_screen.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';

class DiscountShopScreen extends StatefulWidget {
  const DiscountShopScreen({super.key});

  @override
  State<DiscountShopScreen> createState() => _DiscountShopScreenState();
}

class _DiscountShopScreenState extends State<DiscountShopScreen> {
  bool isFavorite = false;

  List productList = [
    'Shoes',
    'High heels',
    'Dress',
    'Watch & Accessories',
    'Bag'
  ];

  List<Color> productContainerColor = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.purple
  ]..shuffle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ShopAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Text('Discount ends in',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                  const Gap(10),
                  discountTimer()
                ],
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: screenWidth(context),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < productList.length; i++)
                        Container(
                            padding: const EdgeInsets.only(
                                left: 6, right: 6, top: 3, bottom: 3),
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: Text(productList[i],
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)))),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(20),
            SizedBox(
              height: screenHeight(context),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 2 / 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2
                ),
                itemBuilder: (context, index) {
                  return productContainer();
                }
                ),
            )
          ])),
        ));
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

  Widget productContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MyBagScreen()));
      },
      child: Container(
        // height: screenHeight(context) * 0.15,
        width: screenWidth(context) * 0.38,
        margin: const EdgeInsets.only(left: 15),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        decoration: const BoxDecoration(
            // border: Border.all(width: 1, color: Colors.black),
            ),
        child: Column(
          children: [
            Image.asset('assets/images/high-heel.png'),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hermes',
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Text('Antelope',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(164, 164, 164, 1),
                        )),
                    const Gap(5),
                    Text('# 400.00',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(51, 160, 88, 1),
                        )),
                    Text('# 400.00',
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(119, 119, 119, 1),
                        ))
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
      ),
    );
  }
}
