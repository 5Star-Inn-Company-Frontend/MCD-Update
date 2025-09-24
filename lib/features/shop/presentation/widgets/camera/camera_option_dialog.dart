import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/widgets/camera/camera_page.dart';

class CameraOptionDialog extends StatefulWidget {
  const CameraOptionDialog({super.key});

  @override
  State<CameraOptionDialog> createState() => _CameraOptionDialogState();
}

class _CameraOptionDialogState extends State<CameraOptionDialog> {
  @override
  Widget build(BuildContext context) {
    return _showCameraOptionDialog();
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
}