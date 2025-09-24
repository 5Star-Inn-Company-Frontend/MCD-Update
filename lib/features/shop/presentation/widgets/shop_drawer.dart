import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/features/shop/presentation/views/category_screen.dart';
import 'package:mcd/features/shop/presentation/views/my_saved_screen.dart';
import 'package:mcd/features/shop/presentation/views/mybag_screen.dart';
import 'package:mcd/features/shop/presentation/views/order_history_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/seller_screen.dart';

class ShopDrawer extends StatefulWidget {
  const ShopDrawer({super.key});

  @override
  State<ShopDrawer> createState() => _ShopDrawerState();
}

class _ShopDrawerState extends State<ShopDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icons/menu.svg'),
            title: Text('Category', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.black),),
            iconColor: Colors.white,
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CategoryScreen()));
            }
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icons/bag.svg'),
            title: Text('My Bag', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.black),),
            iconColor: Colors.white,
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyBagScreen()));
            }
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icons/order-file.svg'),
            title: Text('Order History', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.black),),
            iconColor: Colors.white,
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
            }
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icons/heart.svg'),
            title: Text('My Saved', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.black),),
            iconColor: Colors.white,
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MySavedScreen()));
            }
          ),
          ListTile(
            leading: SvgPicture.asset('assets/icons/upload.svg'),
            title: Text('Seller', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14.sp, color: Colors.black),),
            iconColor: Colors.white,
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SellerScreen()));
            }
          ),
        ]
      )
    );
  }
}