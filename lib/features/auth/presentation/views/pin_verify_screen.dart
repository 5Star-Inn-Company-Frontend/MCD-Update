import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';

class PinVerifyScreen extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

  PinVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final username = Get.arguments['username'];

    return Scaffold(
      appBar: AppBar(title: Text("Verify PIN")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: pinController,
              decoration: InputDecoration(labelText: "Enter PIN"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.verifyPin(context, username, pinController.text.trim());
              },
              child: Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}
