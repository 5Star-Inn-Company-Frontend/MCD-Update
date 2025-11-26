import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Cardtextfield extends StatelessWidget {
  final String tfieldname;
  final TextEditingController? controller;
  const Cardtextfield({super.key, required this.tfieldname, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(tfieldname, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
          ],
        ),
        Gap(5.h),
        TextField(
          controller: controller,
          style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
          cursorColor: const Color.fromRGBO(112, 112, 112, 1),
          decoration: InputDecoration(
            fillColor: const Color.fromRGBO(253, 253, 253, 1),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(112, 112, 112, 1))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(120, 120, 120, 1))
            ),
          ),
        ),
      ],
    );
  }
}