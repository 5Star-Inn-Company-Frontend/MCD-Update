import 'package:mcd/core/import/imports.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import './scan_qrcode_module_controller.dart';

class ScanQrcodeModulePage extends GetView<ScanQrcodeModuleController> {
  ScanQrcodeModulePage({super.key});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _scanWidget(context),
    );
  }

  Widget _scanWidget(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan your QR Code',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.manRope,
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: QRView(
              key: qrKey,
              onQRViewCreated: controller.onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Obx(() => controller.isProcessing
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color.fromRGBO(51, 160, 88, 1),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Processing...',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.manRope,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : _scanButton(context)),
            ),
          )
        ],
      ),
    );
  }

  Widget _scanButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // The scanning is handled by the QR view
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
                    fontSize: 26,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
