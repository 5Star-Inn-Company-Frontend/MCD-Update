import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/logger.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/transaction/presentation/notifiers/transaction.provider.dart';
import 'package:provider/provider.dart';

enum cardValue { visa, mastercard, verve }

class CardTopUpTransactionScreen extends StatefulWidget {
  const CardTopUpTransactionScreen({super.key});

  @override
  State<CardTopUpTransactionScreen> createState() =>
      _CardTopUpTransactionScreenState();
}

class _CardTopUpTransactionScreenState
    extends State<CardTopUpTransactionScreen> {
  final TextEditingController _cardName = TextEditingController();
  final TextEditingController _cardAccountNo = TextEditingController();
  final TextEditingController _expDate = TextEditingController();
  final TextEditingController _ccv = TextEditingController();
  final TextEditingController _amount = TextEditingController();

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

  String _cardType = '';

  void _detectCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      setState(() {
        _cardType = cardValue.visa.toString();
      });
    } else if (cardNumber.startsWith('51') ||
        cardNumber.startsWith('52') ||
        cardNumber.startsWith('53') ||
        cardNumber.startsWith('54') ||
        cardNumber.startsWith('55')) {
      setState(() {
        _cardType = cardValue.mastercard.toString();
      });
    } else if (cardNumber.startsWith('506')) {
      setState(() {
        _cardType = cardValue.verve.toString();
      });
    } else {
      setState(() {
        _cardType = 'Unknown';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Card Top up",
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
                    "Enter your card details and the amount to top up your wallet"),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextSemiBold("Card Number"),
                    _cardType == 'unknown' ||
                            _cardType == '' ||
                            _cardType == cardValue.verve
                        ? Container()
                        : SvgPicture.asset(_cardType == cardValue.mastercard
                            ? AppAsset.mastecard
                            : AppAsset.visa),
                  ],
                ),
                const Gap(6),
                TextFormField(
                  controller: _cardAccountNo,
                  validator: (value) {
                    if (value == null) return ("Input name");
                    if (value.isEmpty) return ("Input valid card no");
                    if (value.length == 16) return ("Enter your 16 number");
                    return null;
                  },
                  onChanged: (String? value) {
                    if (value == null) return;
                    _detectCardType(value.trim().toString());
                    setFormState();
                  },
                  decoration: textInputDecoration.copyWith(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: '0000    0000    0000    0000',
                      hintStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffD9D9D9)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryGrey))),
                ),
                const Gap(30),
                TextSemiBold("Card Name"),
                const Gap(6),
                TextFormField(
                  controller: _cardName,
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
                      hintText: 'Akanji Joseph',
                      hintStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffD9D9D9)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryGrey))),
                ),
                const Gap(30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemiBold("Exp. Date"),
                          const Gap(6),
                          TextFormField(
                            controller: _expDate,
                            validator: (value) {
                              if (value == null) return ("Input name");
                              if (value.isEmpty) return ("Input valid exp date");
                              return null;
                            },
                            onChanged: (String? value) {
                              setFormState();
                            },
                            decoration: textInputDecoration.copyWith(
                                filled: true,
                                fillColor: AppColors.white,
                                hintText: '00//00',
                                hintStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffD9D9D9)),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primaryGrey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primaryGrey))),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemiBold("CCV"),
                          const Gap(6),
                          TextFormField(
                            controller: _ccv,
                            validator: (value) {
                              if (value == null) return ("Input name");
                              if (value.isEmpty || value.length < 3)
                                return ("Input 3 digit");
                              return null;
                            },
                            onChanged: (String? value) {
                              setFormState();
                            },
                            decoration: textInputDecoration.copyWith(
                                filled: true,
                                fillColor: AppColors.white,
                                hintText: '1234',
                                hintStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffD9D9D9)),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primaryGrey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primaryGrey))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                TextSemiBold("Amount"),
                const Gap(6),
                TextFormField(
                  controller: _amount,
                  validator: (value) {
                    if (value == null) return ("Input name");
                    if (value.isEmpty) return ("Input amount");
                    return null;
                  },
                  onChanged: (String? value) {
                    setFormState();
                  },
                  decoration: textInputDecoration.copyWith(
                      filled: true,
                      fillColor: AppColors.white,
                      hintText: '12345.0',
                      hintStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffD9D9D9)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryGrey)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primaryGrey))),
                ),
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
