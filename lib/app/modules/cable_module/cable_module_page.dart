import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/core/import/imports.dart';

class CableModulePage extends GetView<CableModuleController> {
  const CableModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Cable Tv",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(child: TextSemiBold("History")),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              _buildProviderDropdown(),
              const Gap(25),
              _buildSmartCardInput(),
              const Gap(40),
              Obx(() => BusyButton(
                title: "Verify",
                isLoading: controller.isValidating.value,
                onTap: controller.verifyAndNavigate,
              )),
              const Gap(30),
              SizedBox(width: double.infinity, child: Image.asset(AppAsset.banner)),
              const Gap(20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primaryGrey)),
      ),
      child: Obx(() {
        if (controller.isLoadingProviders.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        return DropdownButtonHideUnderline(
          child: DropdownButton<CableProvider>(
            dropdownColor: Colors.white,
            isExpanded: true,
            value: controller.selectedProvider.value,
            items: controller.cableProviders.map((provider) {
              final imageUrl = controller.providerImages[provider.name] ?? controller.providerImages['DEFAULT']!;
              return DropdownMenuItem<CableProvider>(
                value: provider,
                child: Row(children: [
                  Image.asset(imageUrl, width: 40),
                  const Gap(10),
                  Text(provider.name),
                ]),
              );
            }).toList(),
            onChanged: (value) => controller.onProviderSelected(value),
          ),
        );
      }),
    );
  }

  Widget _buildSmartCardInput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffF1F1F1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Smart card Number'),
          const Gap(4),
          TextFormField(
            controller: controller.smartCardController,
            validator: (value) {
              if (value == null || value.isEmpty) return "Card No needed";
              if (value.length < 5) return "Card no not valid";
              return null;
            },
            decoration: const InputDecoration(hintText: '012345678'),
          ),
          Obx(() {
            if (controller.validatedCustomerName.value != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '(${controller.validatedCustomerName.value!})',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}