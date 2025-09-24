import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class PosMapTermScreen extends StatefulWidget {
  const PosMapTermScreen({super.key});

  @override
  State<PosMapTermScreen> createState() => _PosMapTermScreenState();
}

class _PosMapTermScreenState extends State<PosMapTermScreen> {
  final TextEditingController _serialNumbercontroller = TextEditingController();
  String? selectedValue;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Map New Terminal",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Gap(20),
                        
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Serial Number', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
              ],
            ),
            const Gap(5),
            TextField(
              controller: _serialNumbercontroller,
              cursorColor: const Color.fromRGBO(90, 187, 123, 1),
              style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
              decoration: InputDecoration(
                hintText: 'Enter serial number',
                hintStyle: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 0.3)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
                        
            const Gap(20),
                        
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Terminal Type', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
              ],
            ),
                        
            const Gap(10),
                        
            Container(
              height: screenHeight(context) * 0.05,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: Colors.white,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 40,),
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'K11 Terminal',
                        child: Text('K11 Terminal'),
                      ),
                      DropdownMenuItem(
                        value: 'Terminal 2',
                        child: Text('Terminal'),
                      ),
                      DropdownMenuItem(
                        value: 'Terminal 3',
                        child: Text('Terminal'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Gap(20),

            InkWell(
              onTap: () {
                successfulVerifyMapDialog();
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Confirm', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
              ),
            ),)
          ],
        )
      )
    );
  }


  successfulVerifyMapDialog(){
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
                height: screenHeight(context) * 0.32,
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
                      LottieBuilder.asset('assets/lottie/successful_transaction_anim.json', width: screenWidth(context) * 0.14, height: screenHeight(context) * 0.07,),
              
                      const Gap(20),
                      Column(
                        children: [
                          Text('Terminal Mapped!', style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1)),),

                          const Gap(10),
                          Text('You have successfully mapped a New Terminal!', textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w300, color: const Color.fromRGBO(51, 51, 51, 1)),),
                        ],
                      ),
                                
                     
                                
                      const Gap(20),
                      InkWell(
                        onTap: () {
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
                          child: Center(child: Text('Close', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),),
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