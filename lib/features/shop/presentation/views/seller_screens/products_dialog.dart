import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class ProductsDialog extends StatefulWidget {
  final String body;
  const ProductsDialog({super.key, required this.body});

  @override
  State<ProductsDialog> createState() => _ProductsDialogState();
}

class _ProductsDialogState extends State<ProductsDialog> {
  @override
  Widget build(BuildContext context) {
    return _showProductsDialog(
      widget.body
    );
  }

  _showProductsDialog(String body) {
      return Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.3),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
              height: screenWidth(context) * 0.7,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Attention', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(73, 73, 75, 1))),

                  Gap(30.h),

                  Text(body, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(133, 133, 134, 1))),

                  Gap(10.h),

                  Row(
                    children: [
                      BusyButton(
                        title: 'No',
                        onTap: () {},
                        color: Colors.transparent,
                        textColor: const Color.fromRGBO(90, 187, 123, 1),
                      ),

                      BusyButton(
                        title: 'Yes',
                        onTap: () {},
                        color: const Color.fromRGBO(215, 9, 33, 1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),

                  
                ],
              ),
            ),
          ),
        ),
    );
  }
}