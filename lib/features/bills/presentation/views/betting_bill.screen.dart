
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class BettingBillScreen extends StatefulWidget {
  const BettingBillScreen({super.key});

  @override
  State<BettingBillScreen> createState() => _BettingBillScreenState();
}

class _BettingBillScreenState extends State<BettingBillScreen> {
  String? _selectedValue;
  final List<String> items = [
    AppAsset.betting,
    AppAsset.mtn
    // AppAsset.mtn,
    // AppAsset.mtn,
  ];
  String? selectedValue;

  final TextEditingController _phone = TextEditingController();
  final _amount = TextEditingController();


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
        appBar: PaylonyAppBarTwo(title: "Betting", elevation: 0, centerTitle: false, actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              child: TextSemiBold("History", fontWeight: FontWeight.w700, fontSize: 16,),
            ),
          )
        ],),
        body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
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

                            ],

                          ),
                        ),
                        const Gap(30),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            // color: Color(0xffF3FFF7),
                            border: Border.all(
                              color: const Color(0xffE0E0E0)
                            ),

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("User ID", style: TextStyle
                                (
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.manRope
                              ),),
                              TextFormField(
                                controller: _phone,
                              )
                            ],
                          ),
                        ),
                        const Gap(25),
                        TextSemiBold("Deposit Amount"),
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
                                    _amountCard('₦0.00'),
                                    _amountCard('₦0.00'),
                                    _amountCard('₦0.00'),
                                    _amountCard('₦0.00'),
                                    _amountCard('₦0.00'),
                                    _amountCard('₦0.00'),
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
                        BusyButton(title: "Pay", onTap: () {}),
                        const Gap(30),
                        SizedBox(
                            width: double.infinity,
                            child: Image.asset(AppAsset.banner)),
                        const Gap(20)
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }

  Widget _amountCard(String amount) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xffF1F1F1))
      ),
      child: Center(
        child: Text(
          amount,
          style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w500
          ),
        ),
      ),);
  }
}
