import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/bills/models/electricity_model.dart';
import 'package:mcd/features/bills/presentation/views/electricity_payout_screen.dart';
import 'package:mcd/features/bills/presentation/widgets/elctricitydropdown.dart';

class ElectricityScreen extends StatefulWidget {
  
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final List<String> items = [
    'Prepaid',
    'Postpaid'
  ];
final imageTextItems = [
const ElectricityModelItem(text: 'Ikeja Electric', imageUrl: "assets/images/ie.png",),
const ElectricityModelItem(text: 'Ikeja Electric', imageUrl: AppAsset.mtn)
  // ... more options
];
  String? selectedValue;

  final TextEditingController _phone = TextEditingController();
  final _amount = TextEditingController();
  final _meterNo = TextEditingController();

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
    return  Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Electricity",
        centerTitle: false,
        elevation: 0,
        actions: [
        Padding(
          padding: const  EdgeInsets.only(right: 12),
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
                    minHeight: constraints.maxHeight
                ),
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
                          child: DropdownButtonHideUnderline(
                           child:  MyDropdown(items: imageTextItems),
                          ),
                        ),
                          const Gap(25),
                       Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffF1F1F1)
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          TextSmall('Payment Item') ,
                          const Gap(6),
                          DropdownButtonHideUnderline(
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
                                        child: Text(item)
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
                                      padding: EdgeInsets.symmetric(horizontal: 0),
                                      height: 40,
                                      width: double.infinity
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                const Divider(),
                                const Gap(5),
                                TextSmall('Meter Number') ,
                                const Gap(10),
                                    TextFormField(
                                    controller: _meterNo,
                                    validator: (value){
                                      if(value == null)return ("Meter No needed");
                                      if(value.length < 5)return("Meter no not valid");
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      suffix: Icon(Icons.cancel_rounded),
                                        hintText: 'Meter Number',
                                        hintStyle: TextStyle(
                                            color: AppColors.primaryGrey
                                        )
                                    ),
                                  ),
                          const Gap(6),
                          ],),
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
                                    _amountCard('100'),
                                    _amountCard('200'),
                                    _amountCard('500'),
                                    _amountCard('1000'),
                                    _amountCard('2000'),
                                    _amountCard('3000'),
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
                                  Flexible(child:
                                  TextFormField(
                                    controller: _amount,
                                    validator: (value){
                                      if(value == null)return ("Amount needed");
                                      if(value.isEmpty)return("Amount needed");
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: '500.00 - 50,000.00',
                                        hintStyle: TextStyle(
                                            color: AppColors.primaryGrey
                                        )
                                    ),
                                  )
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                        const Gap(40),
                        BusyButton(title: "Pay", onTap: () {
                          if(_formKey.currentState == null)return;
                          if(_formKey.currentState!.validate()){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const ElectricityPayOutScreen()));
                          }
                        }),

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
            _amount.text = amount;
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
