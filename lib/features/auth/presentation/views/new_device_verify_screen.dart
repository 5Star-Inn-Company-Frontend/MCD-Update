import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';

class NewDeviceVerifyScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  NewDeviceVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final username = Get.arguments['username'];

    return Scaffold(
      appBar: AppBar(title: Text("Verify New Device")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: "Enter verification code"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.verifyNewDevice(context, username, codeController.text.trim());
              },
              child: Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}
