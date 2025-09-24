import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/qrcode/my_qrcode_screen.dart';
import 'package:mcd/features/qrcode/qrcode_requestfund_screen.dart';
import 'package:mcd/features/qrcode/qrcode_transfer_screen.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(
          title: 'My QR Code',
          centerTitle: false,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: Column(children: [
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyQRCodeScreen()));
                        },
                        child: qrContainer('assets/icons/bx_scan.svg',
                            'My QR Code', 'Your Unique QR Code'),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const QRCodeTransferScreen()));
                        },
                        child: qrContainer('assets/icons/qr_transfer.svg',
                            'Transfer', 'Transfer to any wallet'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const QRCodeRequestFundScreen()));
                        },
                        child: qrContainer(
                            'assets/icons/qr-request.svg',
                            'Request for Fund',
                            'Request for fund from your friends'),
                      ),
                    ],
                  ),
                ]))));
  }

  Widget qrContainer(String icon, String text1, String text2) {
    return Container(
        alignment: Alignment.center,
        height: screenHeight(context) * 0.2,
        width: screenWidth(context) * 0.4,
        padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(243, 255, 247, 1),
            border: Border.all(
              width: 1,
              color: const Color.fromRGBO(240, 240, 240, 1),
            )),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(height: 10),
              SvgPicture.asset(
                icon,
              ),
              const SizedBox(height: 10),
              Text(text1,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const SizedBox(height: 17),
              Text(text2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w500,
                      fontSize: 12)),
            ])));
  }
}
