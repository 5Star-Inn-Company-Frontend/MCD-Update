
import 'package:mcd/core/import/imports.dart';
import './number_verification_module_controller.dart';

class NumberVerificationModulePage extends GetView<NumberVerificationModuleController> {
  const NumberVerificationModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextSemiBold('Kindly enter the phone number you want to buy airtime/data on'),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Enter phone number to verify",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number.';
                  }
                  if (value.length != 11) {
                    return 'Number must be 11 digits.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Obx(() => BusyButton(
                    title: "Verify Network",
                    isLoading: controller.isLoading.value,
                    onTap: controller.verifyNumber,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}