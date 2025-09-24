import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/functions.dart';
import 'package:collection/collection.dart' show ListExtensions;
import 'package:mcd/features/transaction/presentation/transaction_detail.screen.dart';

import '../../data/model/button_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String filterBy = 'All Time';

  bool isScrollingEnabled = true;

  String? selectedValue;

  final List<String> _months = [
    'January',
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  
  final List<TransactionUIModel> _transactionModel = <TransactionUIModel>[
    TransactionUIModel(name: "Betting Deposit", image: AppAsset.betting, amount: 1000, time: "1:10pm"),
    TransactionUIModel(name: "Airtime Topup", image: AppAsset.mtn, amount: 5000, time: "1:10pm"),
    TransactionUIModel(name: "Received from Akanji Joseph", image: AppAsset.withdrawal, amount: 21000, time: "1:10pm"),
    TransactionUIModel(name: "Withdrawal", image: AppAsset.received, amount: 1000, time: "1:10pm"),
    TransactionUIModel(name: "Data Bundle", image: AppAsset.mtn, amount: 1000, time: "1:10pm"),
  ];

  @override
  void initState() {
    selectedValue = _months.first;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  _showDialog(BuildContext context){
    showDialog(
        context: context,
        // barrierColor: AppColors.white,
        builder: (context) {
          return
            AlertDialog(
              content: Container(
                // height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xffFBFBFB)
                ),
                child: Wrap(
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: TextBold( "Duration", fontSize: 16, fontWeight: FontWeight.w600,)),
                        Positioned(
                            top: 0,
                            right: 2,
                            child: TouchableOpacity(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(Icons.clear, color: AppColors.background,)))
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            child: durationcard("Last 7 Days")),
                        durationcard("Last 14 Days"),
                        durationcard("Last 1  Months"),
                        durationcard("All Time"),
                        durationcard("All")
                      ],
                    )

                  ],
                ),
              ),
            );
        });
  }

  _showFilterDialog(BuildContext context){
    showDialog(
        context: context,
        // barrierColor: AppColors.white,
        builder: (context) {
          return
            AlertDialog(
              content: Container(
                // height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xffFBFBFB)
                ),
                child: Wrap(
                  children: [
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: TextBold( "Filter By", fontSize: 16, fontWeight: FontWeight.w600,)),
                        Positioned(
                            top: 0,
                            right: 2,
                            child: TouchableOpacity(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(Icons.clear, color: AppColors.background,)))
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            child: durationcard("Money in ")),
                        durationcard("Money out"),
                        durationcard("All")
                      ],
                    )

                  ],
                ),
              ),
            );
        }
        );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBar(title: "Transaction History",),
      body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // controller: controller,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextBold("All", fontSize: 16, fontWeight: FontWeight.w500,),
                                TouchableOpacity(
                                    onTap: () => _showFilterDialog(context),

                                    child: const Icon(Icons.keyboard_arrow_down))
                              ],
                            )
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextBold("All Status", fontSize: 16, fontWeight: FontWeight.w500,),
                                TouchableOpacity(
                                    onTap: () => _showFilterDialog(context),

                                    child: const Icon(Icons.keyboard_arrow_down))
                              ],
                            )
                          ]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextBold("Filter", fontSize: 16, fontWeight: FontWeight.w500,),
                                TouchableOpacity(
                                    onTap: () => _showFilterDialog(context),

                                    child: const Icon(Icons.filter_alt_outlined))
                              ],
                            )
                          ]),
                    ),
                  ],
                ),
                const Gap(30),
                Divider(color: AppColors.placeholderColor.withOpacity(0.6)),
               TouchableOpacity(
                 onTap: (){
                   showModalBottomSheet(context: context, builder:(context){
                     return Wrap(
                       children: _months.mapIndexed((index, e) => ListTile(
                         leading: TextSemiBold(e.toString()),
                         onTap: (){
                           setState(() {
                             selectedValue = e.toString();
                             Navigator.pop(context);
                           });
                         },
                       )).toList()

                     );
                   });
                 },
                 child: Row(
                   children: [
                     TextSemiBold(selectedValue.toString(),color: Colors.black),
                     const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryGrey2,)
                   ],
                 ),
               ),
                const Gap(6),
                const Row(
                  children: [
                    Text("In ₦0.00 ", style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),),
                    Gap(10),
                    Text("Out ₦0.00", style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),),
                  ],
                ),
                const Gap(10),
                Divider(color: AppColors.placeholderColor.withOpacity(0.6)),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _transactionModel.length,
                    itemBuilder:(context, index){
                    final value = _transactionModel[index];
                      return transactionCard(value.name, value.image, value.amount, value.time);
                    }
                ),

              ],
            )
      ),
    );
  }
  Widget durationcard(String time) {
    return TouchableOpacity(
      onTap: () {
        setState(() {
          filterBy = time;
        });
        Navigator.pop(context);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12)
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: TextSemiBold(time, fontSize: 14, fontWeight: FontWeight.w400,)),
    );
  }

  Widget transactionCard(String title, String image, double amount, String time) {
  return ListTile(
    onTap: (){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TransactionDetailScreen(name: title, image: image, amount: amount,)),);
    },
    contentPadding: EdgeInsets.zero,
    leading: Image.asset(image, width: 80, height: 80,),
    title: TextSemiBold(title),
    subtitle: TextSemiBold(time),
    trailing: TextSemiBold(Functions.money(amount, "N")),
  );
  }
}