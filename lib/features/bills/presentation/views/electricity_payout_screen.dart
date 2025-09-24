import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/features/bills/presentation/views/electricity_transaction_detail.dart';

class ElectricityPayOutScreen extends StatefulWidget {
  const ElectricityPayOutScreen({super.key});

  @override
  State<ElectricityPayOutScreen> createState() =>
      _ElectricityPayOutScreenState();
}

class _ElectricityPayOutScreenState extends State<ElectricityPayOutScreen> {
  bool points = false;
  int _selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Payout",
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(30),
            const Text(
              '₦15,000',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Gap(30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE0E0E0))),
              child: Column(
                children: [
                  _rowCard(
                    'Amount',
                    '₦15,000',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Biller Name',
                    'Ikeja Electric',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Account Name',
                    'Akanji Joseph',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Account Number',
                    '012345678',
                  ),
                ],
              ),
            ),
            const Gap(20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE0E0E0))),
              child: Row(
                children: [
                  TextSemiBold(
                    'Points',
                    fontSize: 15,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Text(
                        '₦0.00 available',
                       style: TextStyle(
                         fontSize: 15,
                       ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: points,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (bool value) {
                            setState(() {
                              points = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Gap(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold(
                  'Payment Method',
                  fontSize: 13,
                ),
                const Gap(9),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffE0E0E0))),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text('Wallet Balance (₦0.00)'),
                        contentPadding: EdgeInsets.zero,
                        value: 1,
                        activeColor: AppColors.primaryGreen,
                        controlAffinity: ListTileControlAffinity.trailing,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('Mega Bonus (₦0.00)'),
                        contentPadding: EdgeInsets.zero,
                        value: 2,
                        activeColor: AppColors.primaryGreen,
                        controlAffinity: ListTileControlAffinity.trailing,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Gap(40),
                BusyButton(
                    title: "Confirm & Pay",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ElectricityTransactionScreen(
                            amount: 15000,
                            name: 'Ikeja Electric',
                            image: '"assets/images/ie.png",',
                          )));
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _rowCard(String title, String subtitile) {
    return Row(
      children: [
        TextSemiBold(
          title,
          fontSize: 15,
        ),
        const Spacer(),
        Text(
          subtitile,
          style: const TextStyle(
            fontSize: 15,
            // fontFamily: AppFonts.manRope
          ),
        ),
      ],
    );
  }
}
