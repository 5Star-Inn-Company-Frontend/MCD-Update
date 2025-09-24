import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/logger.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/transaction/presentation/notifiers/transaction.provider.dart';
import 'package:provider/provider.dart';

class UssdTransactionScreen extends StatefulWidget {
  const UssdTransactionScreen({super.key});

  @override
  State<UssdTransactionScreen> createState() => _UssdTransactionScreenState();
}

class _UssdTransactionScreenState extends State<UssdTransactionScreen> {
  final TextEditingController _accountName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _selectedValue; // Create a variable to store the selected value

  // List of items for the dropdown
  final List<String> _dropdownItems = [
    'Choose Bank',
    'First Bank',
    'Zenith Bank',
    'Coronation Bank'
  ];

  bool _isformValid = false;

  void setFormState() {
    setState(() {
      if (_formKey.currentState == null) return;
      if (_formKey.currentState!.validate()) {
        logger.d("message");
        _isformValid = true;
      } else {
        _isformValid = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "USSD Top up",
        centerTitle: false,
      ),
      body:
          Consumer<TransactionNotifier>(builder: (context, transaction, child) {
        final bool isGenrating = transaction.transactionState.isGenerating;
        final bool isDisbaled = transaction.transactionState.isDisabled;
        return SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold(
                    "Enter your bank and the amount to generate a ussd code quickly"),
                const Gap(10),
                TextSemiBold("Select Bank"),
                const Gap(6),
                DropdownButtonFormField<String>(
                  elevation: 0,
                  validator: (value) {
                    if (value == null) return ("Select a bank");
                    if (value == "Choose Bank") return ("Select a  valid bank");
                    return null;
                  },
                  decoration: textInputDecoration.copyWith(
                      filled: true,
                      fillColor: AppColors.white,
                      hintStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryGrey))),
                  icon: const Icon(Icons.keyboard_arrow_right),
                  value:
                      _selectedValue ?? "Choose Bank", // Set the current value
                  items: _dropdownItems.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue == null) return;
                      _selectedValue = newValue;
                      setFormState(); // Update the selected value
                    });
                  },
                ),
                const Gap(30),
                TextSemiBold("Select Bank"),
                const Gap(6),
                TextFormField(
                  controller: _accountName,
                  validator: (value) {
                    if (value == null) return ("Input name");
                    if (value.isEmpty) return ("Input valid account name");
                    return null;
                  },
                  onChanged: (String? value) {
                    setFormState();
                  },
                  decoration: textInputDecoration.copyWith(
                      filled: true,
                      fillColor: AppColors.white,
                      hintStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryGrey))),
                ),
                TextSemiBold("(validated name will appear here)"),
                const Gap(30),
                Stack(children: [
                  Opacity(
                    opacity: isDisbaled == false ? 1 : 0.1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryColor, width: 1),
                          color: const Color(0xff5ABB7B).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemiBold(
                            "Copy your Code",
                            fontSize: 20,
                          ),
                          const Gap(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextSemiBold(
                                "*000*000#",
                                fontSize: 20,
                              ),
                              Row(
                                children: [
                                  TextSemiBold(
                                    "Copy",
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                  ),
                                  const Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: AppColors.primaryColor,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  transaction.transactionState.isGenerating
                      ? Positioned(
                          top: 50,
                          right: screenWidth(context) * 0.3,
                          child: const Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.6,
                                    color: Colors.black87,
                                  ),
                                ),
                                Gap(5),
                                Text(
                                  'Generating',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ]),
                const Gap(60),
                Center(
                  child: BusyButton(
                      disabled: _isformValid == true ? false : true,
                      title: "Generate Code",
                      width: screenWidth(context) * 0.7,
                      onTap: () {
                        setState(() {
                          transaction.transactionState.toggleGenerating();
                        });
                      }),
                )
              ],
            ),
          ),
        ));
      }),
    );
  }
}
