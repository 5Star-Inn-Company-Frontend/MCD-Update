import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class PosAuthorizeWithdrawalScreen extends StatefulWidget {
  const PosAuthorizeWithdrawalScreen({super.key});

  @override
  State<PosAuthorizeWithdrawalScreen> createState() => _PosAuthorizeWithdrawalScreenState();
}

class _PosAuthorizeWithdrawalScreenState extends State<PosAuthorizeWithdrawalScreen> {
  final int pinLength = 4;
  List<String> pin = [];
  
  void _onPressed(String value) {
    setState(() {
      if (value == '⌫') {
        if (pin.isNotEmpty) pin.removeLast();
      } else if (pin.length < pinLength) {
        pin.add(value);
      }
    });
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(20.0),
          width: screenWidth(context) * 0.14,
          height: screenHeight(context) * 0.07,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromRGBO(211, 208, 217, 1)),
            borderRadius: BorderRadius.circular(4)
          ),
          child: SizedBox(
            height: screenHeight(context) * 0.008,
            width: screenWidth(context) * 0.016,
            child: CircleAvatar(
              backgroundColor: index < pin.length ? const Color.fromRGBO(112, 112, 112, 1) : Colors.white,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeypadButton(String label) {
    return GestureDetector(
      onTap: () => _onPressed(label),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
         ),
        child: Text(label, style: GoogleFonts.manrope(fontSize: 24.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
      ),
    );
  }

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
          children: [
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Authorize Withdrawal', style: GoogleFonts.manrope(fontSize: 24.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1)),)
              ],
            ),

            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Amount: 500,000.00', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),)
              ],
            ),

            const Gap(150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/lock.svg'),
                const Gap(5),
                Text('Enter Pin to complete transaction', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),)
              ],
            ),

            const Gap(20),
            _buildPinDots(),
            
            const Gap(40),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5, // width / height
                  mainAxisSpacing: 8.0, // horizontal space
                  crossAxisSpacing: 8.0, // vertical space
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) return _buildKeypadButton('');
                  if (index == 10) return _buildKeypadButton('0');
                  if (index == 11) return _buildKeypadButton('⌫');
                  return _buildKeypadButton('${index + 1}');
                },
              ),
            ),

            const Gap(60),
            pin.length == 4
            ? BusyButton(title: 'Confirm Pin', onTap: () {successfulWithdrawalDialog();}, height: screenHeight(context) * 0.065, color: const Color.fromRGBO(90, 187, 123, 1), textColor: Colors.white)
            : BusyButton(title: 'Confirm Pin', onTap: () {}, height: screenHeight(context) * 0.065, color: const Color.fromRGBO(90, 187, 123, 0.3), textColor: Colors.white)
            ]
          )
        )
      );
    }

    successfulWithdrawalDialog(){
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
                      children: [
                        LottieBuilder.asset('assets/lottie/successful_transaction_anim.json', width: screenWidth(context) * 0.14, height: screenHeight(context) * 0.07,),
                
                        const Gap(20),
                        Text('Withdrawal Successful!', style: GoogleFonts.manrope(fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1)),),
                                  
                        const Gap(10),
                        Text('Funds has been deposited to your account', textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w300, color: const Color.fromRGBO(51, 51, 51, 1)),),
                                  
                        const Gap(20),
                        InkWell(
                          // onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosHomeScreen()));},
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