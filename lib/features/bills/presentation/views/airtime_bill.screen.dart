import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/transaction/presentation/transaction_detail.screen.dart';

class AirtimeBillScreen extends StatefulWidget {
  const AirtimeBillScreen({super.key});

  @override
  State<AirtimeBillScreen> createState() => _AirtimeBillScreenState();
}

class _AirtimeBillScreenState extends State<AirtimeBillScreen> {
  String? _selectedValue;
  final List<String> items = [
    AppAsset.mtn,
    "assets/images/airtel.png",
    // AppAsset.mtn,
    // AppAsset.mtn,
  ];
  String? selectedValue;

  final TextEditingController _phone = TextEditingController();
  final _amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    selectedValue = items.first;
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(title: "Airtime", centerTitle: false, 
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            child: TextSemiBold("History", fontWeight: FontWeight.w700, fontSize: 16,),
          ),
        )
      ],
      ),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.primaryGrey
                              )
                            )
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    // isDense: false,
                                    iconStyleData: const IconStyleData(
                                        icon: Icon(Icons.keyboard_arrow_down_rounded,size: 30,)
                                    ),
                                    items: items
                                        .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: Image.asset(
                                          item,
                                          width: 50,
                                          //   fontSize: 14,
                                          // ),
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 140,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                ),
                    
                    
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 3,
                                height: 30,
                                decoration: const BoxDecoration(
                                    color: AppColors.primaryGrey
                                ),
                              )
                              , Flexible(
                                flex: 3,
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null)return ("Pls input phone number");
                                    if(value.length != 11)return ("Pls Input valid number");
                                    return null;
                                  },
                                  decoration: textInputDecoration.copyWith(
                                      filled: false,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      suffixIcon: const Icon(Icons.person_2_outlined)
                                  ),
                                  controller: _phone,
                                ),
                              ),
                    
                    
                            ],
                    
                          ),
                        ),
                        const Gap(30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xffF3FFF7),
                            border: Border.all(
                              color: AppColors.primaryColor,
                            ),
                    
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Bonus ₦10", style: TextStyle
                                (
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                // fontFamily: AppFonts.manRope
                              ),),
                              // TextSemiBold("Select Amount"),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: TextSemiBold("Claim", color: AppColors.white,),
                              )
                            ],
                          ),
                        ),
                        const Gap(25),
                        TextSemiBold("Select Amount"),
                        const Gap(14),
                        Container(
                          height: screenHeight(context) * 0.27,
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffF1F1F1)
                            )
                          ),
                          child: Column(
                            children: [
                              Flexible(
                                child: GridView(
                    
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150, // Adjust as per your needs
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 3 / 1.3, // Adjust aspect ratio as per your needs
                                  ),
                                  children: [
                                    _amountCard('50'),
                                    _amountCard('100'),
                                    _amountCard('200'),
                                    _amountCard('500'),
                                    _amountCard('1000'),
                                    _amountCard('2000'),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Text("₦", style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  ),),
                                  const Gap(8),
                                  Flexible(child:TextFormField(
                                    controller: _amount,
                                    validator: (value){
                                      if(value == null)return ("Pls input amount");
                                      if(value.isEmpty)return ("Pls input amount");
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: '500.00 - 50,000.00',
                                        hintStyle: TextStyle(
                                            color: AppColors.primaryGrey
                                        )
                                    ),
                                  ))
                                ],
                              ),
                    
                            ],
                          ),
                        ),
                        const Gap(40),
                        BusyButton(title: "Pay",
                          onTap: (){
                          if(_formKey.currentState == null)return;
                          if(_formKey.currentState!.validate()){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => TransactionDetailScreen(name: "Airtime Top Up", image: selectedValue.toString(), amount: double.parse(_amount.text.toString()))),);
                          }

                          },
                        ),
                        const Gap(30),
                        SizedBox(
                            width: double.infinity,
                            child: Image.asset(AppAsset.banner)),
                        const Gap(20)
                      ],
                    ),
                  ),
                ),
              ),
            );
    }
      )
    );
  }

  Widget _amountCard(String amount) {
    return TouchableOpacity(
      onTap: (){
        if(mounted){
          setState(() {
            _amount.text = amount.trim();
          });
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xffF1F1F1))
        ),
        child: Center(
          child: Text(
          '₦$amount',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w500
          ),
              ),
        ),),
    );
  }
}
