
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/bills/presentation/widgets/day_plan.dart';
import 'package:mcd/features/bills/presentation/widgets/night_plan.dart';

class DataBillScreen extends StatefulWidget {
  const DataBillScreen({super.key});

  @override
  State<DataBillScreen> createState() => _DataBillScreenState();
}

class _DataBillScreenState extends State<DataBillScreen> with SingleTickerProviderStateMixin{
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
  late TabController _tabController;

  final List<PlanDuration> _tadbs = [
    PlanDuration(no: 0, component: const DayPlanWidget(),),
    PlanDuration(no: 1, component: const NightPlanWidget(),)

  ];

  final List<DataPlan> _tabBar = [
    DataPlan(name: 'Daily', no: 0),
    DataPlan(name: 'Night', no: 1),
    DataPlan(name: 'Weekend', no: 2),
    DataPlan(name: 'Weekly', no: 3),
    DataPlan(name: 'Monhtly', no: 4),
  ];

  DataPlan? _selectedTab;
  PageController controller = PageController();



  @override
  void initState() {
    selectedValue = items.first;
    _tabController = TabController(length: 3, vsync: this);
    _selectedTab = _tabBar.first;
    super.initState();
  }



  @override
  void dispose() {
    _phone.dispose();
    _amount.dispose();
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PaylonyAppBarTwo(title: "Data bundle", centerTitle: false, actions: [
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
                                  decoration: textInputDecoration.copyWith(
                                      filled: false,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
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
                        const Gap(20),
                        SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryGrey.withOpacity(0.4)
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _tabBar
                                  .map((item) => Row(
                                children: [
                                  TouchableOpacity(
                                    onTap: (){
                                      setState(() {
                                        if(!mounted)return;
                                        _selectedTab = item;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: item == _tabBar.last ? AppColors.white : AppColors.primaryGrey
                                          )
                                        )
                                      ),
                                        child: TextSemiBold(item.name, color: item == _selectedTab ? AppColors.primaryColor : AppColors.textPrimaryColor,)),
                                  ),
                          
                                   // Add spacing between items
                                ],
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Column(
                          children: _tadbs.map((e) => Visibility(
                            visible: e.no == _selectedTab?.no,
                            child: SizedBox(
                              height: screenHeight(context) * 0.30,
                                child: e.component),
                          )).toList(),
                        ),

                        const Gap(25),

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


class DataPlan {
  final String name;
  final int no;

  DataPlan({
    required this.name,
    required this.no
});

}

class PlanDuration {
  final int no;
  final Widget component;

  PlanDuration({
    required this.no,
    required this.component
});
}
