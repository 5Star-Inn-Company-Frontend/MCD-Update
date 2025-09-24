import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class CardButton extends StatefulWidget {
  final void Function()? onTap;
  final String text;
  const CardButton({super.key, this.onTap, required this.text});

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: screenHeight(context) * 0.065,
        width: screenWidth(context) * 0.5,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(90 , 180, 123, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(widget.text, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
      ),
    ),);
  }
}