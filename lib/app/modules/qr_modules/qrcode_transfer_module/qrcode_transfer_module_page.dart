import 'package:mcd/core/import/imports.dart';

import './qrcode_transfer_module_controller.dart';

class QrcodeTransferModulePage extends GetView<QrcodeTransferModuleController> {
  const QrcodeTransferModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: 'Transfer',
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Scan the other party QR Code to transfer too',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppFonts.manRope,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.1),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.SCAN_QRCODE_MODULE);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
