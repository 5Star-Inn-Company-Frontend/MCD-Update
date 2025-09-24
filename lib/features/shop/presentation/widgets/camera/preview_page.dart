import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/views/shop_screen.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.picture});

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ShopScreen()));
          },
          iconSize: 30,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: screenHeight(context) * 0.07),
            ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.file(File(picture.path), fit: BoxFit.cover, width: screenWidth(context) * 0.8)),
            const SizedBox(height: 30),
            Text(picture.name, style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500))
          ]),
        ),
      ),
    );
  }
}