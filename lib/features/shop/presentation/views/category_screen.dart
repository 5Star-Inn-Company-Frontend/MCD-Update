import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
              const Gap(10),
              SizedBox(
                height: screenHeight(context) * 0.9,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.65
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    categoryItem(const Color.fromRGBO(254, 60, 141, 1), 'New Product', 'assets/images/category1.png'),
                    categoryItem(const Color.fromRGBO(125, 127, 136, 1), 'Famous Brand', 'assets/images/category2.png'),
                    categoryItem(const Color.fromRGBO(254, 165, 60, 1), 'Muslim Dress', 'assets/images/category3.png'),
                    categoryItem(const Color.fromRGBO(236, 119, 82, 1), 'Sport', 'assets/images/category4.png'),
                    categoryItem(const Color.fromRGBO(254, 60, 246, 1), 'New Product', 'assets/images/category5.png'),
                    categoryItem(const Color.fromRGBO(82, 236, 217, 1), 'New Product', 'assets/images/category6.png'),
                  ]
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  Widget categoryItem(Color containerColor, String text, String imagePath) {
    // return Container(
    //   // height: screenHeight(context) * 0.4,
    //   // width: screenWidth(context),
    //   color: containerColor,
    //   child: Stack( 
    //     children: [
    //       Positioned(
    //         bottom: 0, left: 0, right: 0, top: 50,
    //         child: Image.asset(imagePath, fit: BoxFit.fill,)
    //       ),
    //       Container(
    //         // color: LinearGradient(colors: colors),
    //         alignment: Alignment.bottomCenter, 
    //         child: Text(text, textAlign: TextAlign.center , style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.white),),
    //       ),
    //     ]
    //   )
    // );


    return Container(
      // color: containerColor,
      decoration: BoxDecoration(
        color: containerColor,
        image: DecorationImage(
          alignment: const Alignment(0, 0),
          image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 200),
      child: Text(text, textAlign: TextAlign.center , style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.sp, color: Colors.white),),
    );
  }
}