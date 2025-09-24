import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:mcd/features/pos/presentation/views/pos_term_agreement_screen.dart';

class PosUploadLocationScreen extends StatefulWidget {
  const PosUploadLocationScreen({super.key});

  @override
  State<PosUploadLocationScreen> createState() => _PosUploadLocationScreenState();
}

class _PosUploadLocationScreenState extends State<PosUploadLocationScreen> {
  String? selectedFileName;
  bool fileUploaded = false;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        fileUploaded = true; // File upload simulation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Upload location",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),
            Text('Follow this process to upload your location details', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

            Gap(15.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Take a picture of your Business Location', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                Gap(5.h),
                Text('2. Upload image', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                Gap(5.h),
                Text('3. Submit image', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),

            Gap(40.h),

            _fileUploadContainer(),

            Gap(20.h),

            InkWell(
              onTap: fileUploaded ? () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTermAgreementScreen()));
              } : selectFile,
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text(
                  fileUploaded ? 'Proceed' : 'Upload Image', 
                  style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
              ),
            ),)
          ]
        )
      )
    );
  }


  Widget _fileUploadContainer() {
    return GestureDetector(
      onTap: selectFile,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [12, 6],
        strokeWidth: 3,
        color: fileUploaded ? const Color.fromRGBO(51, 160, 88, 1) : const Color.fromRGBO(112, 112, 112, 1),
        child: SizedBox(
          height: screenHeight(context) * 0.4,
          width: double.infinity,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedFileName == null ? 'Click here to Upload Document\n(5MB max)' : selectedFileName!,
                    textAlign: TextAlign.center, 
                    style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, 
                      color: selectedFileName == null ? const Color.fromRGBO(112, 112, 112, 1) : const Color.fromRGBO(51, 160, 88, 1)
                    ),
                  ),
                    
                  Gap(20.h),
                    
                  Icon(Icons.image_outlined, size: 150, weight: 30,
                    color: selectedFileName == null ? const Color.fromRGBO(112, 112, 112, 1) : const Color.fromRGBO(51, 160, 88, 1)
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}