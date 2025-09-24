import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PosTermOtpScreen extends StatefulWidget {
  const PosTermOtpScreen({super.key});

  @override
  State<PosTermOtpScreen> createState() => _PosTermOtpScreenState();
}

class _PosTermOtpScreenState extends State<PosTermOtpScreen> {
  int pinLength = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "",
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
            SizedBox(
              height: screenHeight(context) * 0.8,
              child: Column(
                children: [
                  const Gap(20),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Enter OTP', style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
                    ],
                  ),
              
                  const Gap(30),
              
                  Text(
                    'Enter 4 digit verification code sent to your Email address', 
                    textAlign: TextAlign.start,
                    style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
              
                  const Gap(30),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: PinCodeTextField(
                      appContext: context,
                      length: pinLength,
                      keyboardType: TextInputType.number,
                      textStyle: GoogleFonts.manrope(fontSize: 32.sp, fontWeight: FontWeight.w300, color: const Color.fromRGBO(51, 51, 51, 1)),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(4),
                        fieldHeight: screenHeight(context) * 0.08,
                        fieldWidth: screenWidth(context) * 0.14,
                        activeFillColor: Colors.transparent,
                        activeColor: const Color.fromRGBO(90, 187, 123, .2),
                        selectedFillColor: Colors.transparent,
                        selectedColor: const Color.fromRGBO(90, 187, 123, .2),
                        inactiveFillColor: Colors.transparent,
                        inactiveColor: const Color.fromRGBO(90, 187, 123, .2),
                      ),
                      cursorColor: Colors.transparent,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      onChanged: (value) {
                        // print(value);
                      },
                      onCompleted: (value) {
                    
                        // Navigator.pushReplacement(context,
                        //   MaterialPageRoute(builder: (context) => const SettingUpPasswordScreen())
                      //  );
                      },
                    ),
                  ),
              
                  TextButton(
                    onPressed: () {},
                    child: Text('Resend OTP?', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(90, 187, 123, 1),),)
                  )
                ]
              ),
            ),

            InkWell(
              onTap: () {
                successfulVerifyDialog();
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: pinLength == 4 ? const Color.fromRGBO(51, 160, 88, 1) : const Color.fromRGBO(51, 160, 88, .3),
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


  successfulVerifyDialog(){
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
                          Text('Terminal PIN Changed!', style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1)),),

                          const Gap(10),
                          Text('You have successfully changed your Terminal pin!', textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w300, color: const Color.fromRGBO(51, 51, 51, 1)),),
                        ],
                      ),
                                
                     
                                
                      const Gap(20),
                      InkWell(
                        // onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosHomeScreen()));},
                        onTap: () {
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