import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/models/item_model.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class MyBagScreen extends StatefulWidget {
  const MyBagScreen({super.key});

  @override
  State<MyBagScreen> createState() => _MyBagScreenState();
}

class _MyBagScreenState extends State<MyBagScreen> {
  bool isFavorite = false;
  bool itemSelected = true;
  bool? selectedValue = false;
  bool cartIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      drawer: const ShopDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Column(children: [
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'My Bag',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(90, 187, 123, 1),
                        ),
                        children: [
                          TextSpan(
                            text: cartIsEmpty ?' (0 items)' : ' (${itemsList.length} items)',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(90, 187, 123, 1),
                            ),
                          )
                        ]),
                  ),
                ],
              ),
              const Gap(10),
              // cartIsEmpty ? emptyCart() : cartNotEmpty()
              cartNotEmpty()
            ]),
          )
        ),
      )
    );
  }

  Widget cartItem(Item item) {
    return Column(
      children: [
        SizedBox(
          // height: screenHeight(context) * 0.12,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth(context) * 0.26,
                child: Image.asset(item.image, fit: BoxFit.fill,)
              ),
              SizedBox(
                width: screenWidth(context) * 0.64,
                height: screenHeight(context) * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.black),),
                            Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 11.sp, color: const Color.fromRGBO(119, 119, 119, 1)),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Size', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 11.sp, color: const Color.fromRGBO(119, 119, 119, 1)),),
                                Container(
                                  width: screenWidth(context) * 0.1,
                                  height: screenHeight(context) * 0.02,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                )
                              ],
                            ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quantity', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 11.sp, color: const Color.fromRGBO(119, 119, 119, 1)),),
                                Container(
                                  width: screenWidth(context) * 0.1,
                                  height: screenHeight(context) * 0.02,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('#398.90', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13.sp, color: const Color.fromRGBO(51, 160, 88, 1)),),
                            Text('#402.00', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 9.sp, color: const Color.fromRGBO(119, 119, 119, 1)),),
                          ],
                        ),
                        
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            itemSelected
                            ? InkWell(onTap: (){}, child: SvgPicture.asset('assets/icons/delete-cart-item.svg', width: 20, height: 20))
                            : Checkbox(
                              activeColor: const Color.fromRGBO(51, 160, 88, 1),
                              value: selectedValue,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]
          ),
        ),
      ],
    );
  }

  Widget cartNotEmpty() {
    return Column(
      children: [
        SizedBox(
          height: screenHeight(context) * 0.5,
          child: ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onLongPress: () {
                      
                      setState(() {
                        itemSelected = false;
                      });
                    },
                    child: cartItem(itemsList[index])
                  ),
                  const Gap(10)
                ],
              );
            }
          ),
        ),
        const Gap(20),
        Container(
          width: double.infinity,
          height: screenHeight(context) * 0.07,
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(199, 199, 199, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth(context) * 0.6,
                height: screenHeight(context) * 0.035,
                child: TextField(
                  cursorColor: Colors.black,
                  style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 10, left: 10),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Voucher/Gift Card',
                      hintStyle: GoogleFonts.poppins(
                          color: const Color.fromRGBO(164, 164, 164, 1),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              BusyButton(
                title: 'Apply',
                onTap: () {},
                width: screenWidth(context) * 0.2,
                height: screenHeight(context) * 0.035,
              )
            ],
          ),
        ),
        const Gap(20),
        SizedBox(
          height: screenHeight(context) * 0.05,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sub total (4 product)',
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shipping',
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                            )),
                        Text('From OYAYUBI',
                            style: GoogleFonts.poppins(
                              fontSize: 6.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(119, 119, 119, 1),
                            )),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₦797.8',
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        )),
                    Text('FREE',
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        const Gap(10),
        const Divider(),
        SizedBox(
          height: screenHeight(context) * 0.05,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1),)),
                Text('₦797.8', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(90, 187, 123, 1),)),
              ],
            ),
          ),
        ),
        const Gap(5),
        BusyButton(title: 'CHECKOUT', onTap: () {}, width: screenWidth(context) * 0.6, color: const Color.fromRGBO(90, 187, 123, 1)),
        const Gap(20),
        if (itemSelected = false)
        Row(
          children: [
            BusyButton(title: 'Save for later', onTap: () {}, color: const Color.fromRGBO(90, 187, 123, 1)),
            BusyButton(title: 'Remove', onTap: () {}, color: const Color.fromRGBO(254, 79, 60, 1)),
          ],
        )

      ],
    );
  }

  Widget emptyCart() {
    return Column(
      children: [
        const Gap(80),
        SvgPicture.asset('assets/icons/empty-bag.svg', width: screenWidth(context) * 0.4, height: screenHeight(context) * 0.2,),
        const Gap(10),
        Text('Your bag is empty', style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(71, 71, 71, 1),)),
        const Gap(10),
        BusyButton(title: 'SHOP NOW', onTap: () {}, color: const Color.fromRGBO(90, 187, 123, 1), width: screenWidth(context) * 0.4, height: screenHeight(context) * 0.05,),
        const Gap(50),
        const Divider(),
        const Gap(20),
        SizedBox(
          height: screenHeight(context) * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemsList.length,
            itemBuilder: (BuildContext context, index) {
              return shoeProductContainer(itemsList[index]);
            }
          ),
        ),
        const Divider(),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Your wishlist item', style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(90, 187, 123, 1),)),
          ],
        ),
        const Gap(20),
        SizedBox(
          height: screenHeight(context) * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemsList.length,
            itemBuilder: (BuildContext context, index) {
              return shoeProductContainer(itemsList[index]);
            }
          ),
        ),
      ],
    );
  }

  Widget shoeProductContainer(Item item) {
    return Container(
      // height: screenHeight(context) * 0.15,
      width: screenWidth(context) * 0.34,
      margin: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
          // border: Border.all(width: 1, color: Colors.black),
          ),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 0.12, width: screenWidth(context) * 0.34,
            child: FittedBox(fit: BoxFit.fill, child: Image.asset(item.image,),)
          ),
          const Gap(10),
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
}
