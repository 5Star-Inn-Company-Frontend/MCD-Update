import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/qrcode/qrcode_transfer_details_screen.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  String? result;
  late QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: scanWidget());
  }

  Widget scanWidget() {
    return Center(
      child: Column(
        children: <Widget>[
          const Expanded(
              flex: 1,
              child: Text(
                'Scan your QR Code',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.manRope,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              )),
          Expanded(
            flex: 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: result != null
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const QRCodeTransferDetailsScreen()))
                    : scanButton()),
          )
        ],
      ),
    );
  }

  scanButton() {
    return InkWell(
      onTap: () {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             const QRCodeTransferDetailsScreen()));
      },
      child: SizedBox(
        height: screenHeight(context) * 0.08,
        width: screenWidth(context) * 0.7,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(51, 160, 88, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  'assets/icons/scan_icon.svg',
                  height: 33,
                ),
                const Text(
                  'Scan QR Code',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w400,
                      fontSize: 26),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
