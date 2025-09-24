import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class PosDropdown extends StatefulWidget {
  String ddname;
  String? selectedValue;
  List<DropdownMenuItem<String>> listdd;
  PosDropdown({super.key, required this.selectedValue, required this.listdd, required this.ddname});

  @override
  State<PosDropdown> createState() => _PosDropdownState();
}

class _PosDropdownState extends State<PosDropdown> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.ddname, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
          ],
        ),
        Gap(5.h),
        Container(
          height: screenHeight(context) * 0.05,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromRGBO(120, 120, 120, 1), width: 1)
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuWidth: screenWidth(context),
                borderRadius: BorderRadius.circular(8),
                dropdownColor: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16),
                style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 40,),
                value: widget.selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    widget.selectedValue = newValue;
                  });
                },
                items: widget.listdd
              ),
            ),
          ),
        ),
      ],
    );
  }
}