import 'package:flutter/material.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQRCodeScreen extends StatefulWidget {
  const MyQRCodeScreen({super.key});

  @override
  State<MyQRCodeScreen> createState() => _MyQRCodeScreenState();
}

class _MyQRCodeScreenState extends State<MyQRCodeScreen> {
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('tesd',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.manRope,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      const SizedBox(height: 15),
                      const Text('admnin@5starcompany.com.ng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.manRope,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      const SizedBox(height: 20),
                      Center(
                        child: QrImageView(
                          data: 'Name Name',
                          version: QrVersions.auto,
                          size: screenHeight(context) * 0.38,
                          gapless: true,
                        ),
                      ),
                      SizedBox(height: screenHeight(context) * 0.07),
                      BusyButton(
                          height: screenHeight(context) * 0.06,
                          width: screenWidth(context) * 0.5,
                          title: "Save my QR",
                          onTap: () {}),
                    ]))));
  }
}
