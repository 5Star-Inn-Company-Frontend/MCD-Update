import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:camera/camera.dart';
import 'package:mcd/features/shop/presentation/widgets/camera/camera_page.dart';


class ShopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ShopAppBar({super.key});

  @override
  State<ShopAppBar> createState() => _ShopAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _ShopAppBarState extends State<ShopAppBar> {

  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';

  final List<Map<String, String>> product_history = [

  ];

  List<Map<String, String>> get _filteredHistory {
    if (_searchQuery.isEmpty) {
      return product_history;
    } else {
      return product_history
          .where((entry) => entry['original']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  late List<Map<String, String>> _history;

  @override
  void initState() {
    super.initState();
    _history = product_history;
  }
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: searchAppBar(),
      ),
      centerTitle: false,
      titleSpacing: 0.0,
      actions: [
        GestureDetector(
          onTap: () {
            _showCameraOptionDialog();
          },
          child: SvgPicture.asset('assets/icons/camera.svg')),
        SizedBox(
          width: screenWidth(context) * 0.03,
        )
      ],
    );
  }


  _showCameraOptionDialog() {
    showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.3),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              height: screenWidth(context) * 0.2,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      await availableCameras().then((value) => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/camera.svg', colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),),
                        const Gap(20),
                        Text('Camera', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
              
                  const Divider(),
              
                  Row(
                    children: [
                      const Icon(Icons.photo),
                      const Gap(20),
                      Text('Gallery', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }


  Widget searchAppBar() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              'assets/icons/circle-three-dots.svg',
            ),
            onPressed: () => Scaffold.of(context).openDrawer()
          ),
          
        ),
        // const Gap(10),
        SizedBox(
          height: screenHeight(context) * 0.05,
          width: screenWidth(context) * 0.78,
          child: TextField(
            cursorColor: Colors.black,
            style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w400, color: Colors.black),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 10),
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search what you need',
              hintStyle: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(192, 192, 192, 1)),
              filled: true,
              fillColor: const Color.fromRGBO(238, 238, 238, 1),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ),
      ],
    );
  }
}