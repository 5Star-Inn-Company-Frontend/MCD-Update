import 'package:mcd/core/import/imports.dart';
import 'package:qr_flutter/qr_flutter.dart';
import './my_qrcode_module_controller.dart';

class MyQrcodeModulePage extends GetView<MyQrcodeModuleController> {
  const MyQrcodeModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: 'My QR Code',
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Obx(() => Text(
                    '@${controller.username}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )),
              const SizedBox(height: 10),
              Obx(() => Text(
                    controller.email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )),
              const SizedBox(height: 30),
              Center(
                child: Obx(() => QrImageView(
                      data: controller.qrData,
                      version: QrVersions.auto,
                      size: screenHeight(context) * 0.38,
                      gapless: true,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color.fromRGBO(51, 160, 88, 1),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color.fromRGBO(51, 160, 88, 1),
                      ),
                      embeddedImage: const AssetImage('assets/images/mcdagentlogo.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(screenHeight(context) * 0.08, screenHeight(context) * 0.08),
                      ),
                    )),
              ),
              SizedBox(height: screenHeight(context) * 0.05),
              BusyButton(
                height: screenHeight(context) * 0.06,
                width: screenWidth(context) * 0.5,
                title: "Save my QR",
                onTap: controller.saveQRCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}