import 'package:flutter/material.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/bills/models/cable_tv_model.dart';
import 'package:mcd/features/bills/presentation/views/cable_tv_payoutscreen.dart';
import 'package:mcd/features/bills/presentation/widgets/cable_dropdown.dart';
import 'package:mcd/features/bills/presentation/widgets/month_cable_plan.dart';

class CableTvScreen extends StatefulWidget {
  const CableTvScreen({super.key});

  @override
  State<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends State<CableTvScreen>
    with SingleTickerProviderStateMixin {
  final imageTextItems = [
    const CableModelItem(
      text: 'GOtv',
      imageUrl: "assets/images/gotv.png",
    ),
    const CableModelItem(text: 'DSTV', imageUrl: AppAsset.mtn)
    // ... more options
  ];
  String? selectedValue;
 final _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final _amount = TextEditingController();
  late TabController _tabController;
  final _smartNo = TextEditingController();
  final List<PlanDuration> _tadbs = [
    PlanDuration(
      no: 0,
      component: const CableMonthPlanWidget(),
    ),
  ];

  final List<DataPlan> _tabBar = [
    DataPlan(name: '1 Month', no: 0),
    DataPlan(name: '2 Month', no: 1),
    DataPlan(name: '3 Month', no: 2),
    DataPlan(name: '4 Month', no: 3),
    DataPlan(name: '5 Month', no: 4),
  ];

  DataPlan? _selectedTab;
  PageController controller = PageController();

  @override
  void initState() {
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
        appBar: PaylonyAppBarTwo(
          title: "Cable Tv",
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                child: TextSemiBold(
                  "History",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
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
                                bottom:
                                    BorderSide(color: AppColors.primaryGrey))),
                        child: DropdownButtonHideUnderline(
                          child: MyCDropdown(items: imageTextItems),
                        ),
                      ),
                      const Gap(25),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffF1F1F1))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextSmall('Smart card Number'),
                            const Gap(4),
                            TextFormField(
                              controller: _smartNo,
                              validator: (value) {
                                if (value == null) return ("Meter No needed");
                                if (value.length < 5) return ("Meter no not valid");
                                return null;
                              },
                              decoration: const InputDecoration(
                                  suffix: Icon(Icons.cancel_rounded),
                                  hintText: '012345678',
                                  hintStyle:
                                      TextStyle(color: AppColors.primaryGrey)),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.primaryGrey.withOpacity(0.4))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _tabBar
                                .map((item) => Row(
                                      children: [
                                        TouchableOpacity(
                                          onTap: () {
                                            setState(() {
                                              if (!mounted) return;
                                              _selectedTab = item;
                                            });
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: item ==
                                                                  _tabBar.last
                                                              ? AppColors.white
                                                              : AppColors
                                                                  .primaryGrey))),
                                              child: TextSemiBold(
                                                item.name,
                                                color: item == _selectedTab
                                                    ? AppColors.primaryColor
                                                    : AppColors.textPrimaryColor,
                                              )),
                                        ),
                  
                                        // Add spacing between items
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      const Gap(20),
                      InkWell(
                        onTap: () {
                          if(_formKey.currentState == null)return;
                          if(_formKey.currentState!.validate()){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const CablePayoutScreen()));
                          }
                        },
                        child: Column(
                          children: _tadbs
                              .map((e) => Visibility(
                                    visible: e.no == _selectedTab?.no,
                                    child: SizedBox(
                                        height: screenHeight(context) * 0.30,
                                        child: e.component),
                                  ))
                              .toList(),
                        ),
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
            ),
          );
        }));
  }


}

class DataPlan {
  final String name;
  final int no;

  DataPlan({required this.name, required this.no});
}

class PlanDuration {
  final int no;
  final Widget component;

  PlanDuration({required this.no, required this.component});
}
