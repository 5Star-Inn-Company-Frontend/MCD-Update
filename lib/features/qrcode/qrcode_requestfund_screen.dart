import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/qrcode/qrcode_requestfund_details_screen.dart';

class QRCodeRequestFundScreen extends StatefulWidget {
  const QRCodeRequestFundScreen({super.key});

  @override
  State<QRCodeRequestFundScreen> createState() =>
      _QRCodeRequestFundScreenState();
}

class _QRCodeRequestFundScreenState extends State<QRCodeRequestFundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(
          title: 'Request for Fund',
          centerTitle: false,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const Text('Scan the other party QR Code to transfer too',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppFonts.manRope,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  SizedBox(height: screenHeight(context) * 0.1),
                  Center(
                      child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const QRCodeRequestFundDetailsScreen()));
                    },
                    child: SizedBox(
                      height: screenHeight(context) * 0.058,
                      width: screenWidth(context) * 0.38,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: const Color.fromRGBO(51, 160, 88, 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset('assets/icons/scan_icon.svg'),
                              const Text(
                                'Scan QR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.manRope,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                ]))));
  }
}
