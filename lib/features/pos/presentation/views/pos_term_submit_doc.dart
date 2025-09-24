import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class PosTermSubmitDocScreen extends StatefulWidget {
  const PosTermSubmitDocScreen({super.key});

  @override
  State<PosTermSubmitDocScreen> createState() => _PosTermSubmitDocScreenState();
}

class _PosTermSubmitDocScreenState extends State<PosTermSubmitDocScreen> {
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
        title: "Submit Document",
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
            Gap(50.h),

            _fileUploadContainer(),

            Gap(20.h),

            Text('Please make sure your document have been duly signed before submiting.', 
              style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),

            Gap(40.h),

            InkWell(
              onTap: fileUploaded ? () {
                successfulSubmissionDialog();
              } : selectFile,
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text(
                  fileUploaded ? 'Submit Document' : 'Upload Document', 
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
        strokeCap: StrokeCap.round,
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
                    selectedFileName == null ? 'Click here to Upload Document' : selectedFileName!,
                    textAlign: TextAlign.center, 
                    style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, 
                      color: selectedFileName == null ? const Color.fromRGBO(112, 112, 112, 1) : const Color.fromRGBO(51, 160, 88, 1)
                    ),
                  ),
                    
                  Gap(20.h),

                  SvgPicture.asset('assets/icons/document.svg'),
                    
                ],
              )
            ),
          ),
        ),
      ),
    );
  }

  successfulSubmissionDialog(){
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              child: Container(
                height: screenHeight(context) * 0.4,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset('assets/lottie/successful_transaction_anim.json', width: screenWidth(context) * 0.16, height: screenHeight(context) * 0.08,),
              
                      const Gap(20),
                      Column(
                        children: [
                          Text('Submitted\nSuccessfully', style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1)),),

                          const Gap(10),
                          Text('Your Document will be reviewed and you will be notified shortly.', textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w300, color: const Color.fromRGBO(51, 51, 51, 1)),),
                        ],
                      ),
                                
                      const Gap(20),
                      InkWell(
                        // onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosHomeScreen()));},
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: screenHeight(context) * 0.06,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(90, 187, 123, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Text('Complete', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),),
                        ),
                      ),
                    ]
                  )
                )
              ),
            ),
          )
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}