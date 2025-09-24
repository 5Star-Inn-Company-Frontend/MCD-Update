import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/features/bills/presentation/views/cable_transaction_screen.dart';

class CablePayoutScreen extends StatefulWidget {
  const CablePayoutScreen({super.key});

  @override
  State<CablePayoutScreen> createState() => _CablePayoutScreenState();
}

class _CablePayoutScreenState extends State<CablePayoutScreen> {
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
            Image.asset('assets/images/gotv.png', height: 41,width: 41,),
            Text(
              'Gotv',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
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
                    'Account Name',
                    'Akanji Joseph',
                  ),
                   const Gap(15),
                  _rowCard(
                    'Biller Name',
                    'Gotv',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Smartcard Number',
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
              child: Column(
                children: [
                  _rowCard(
                    'Current Bouquet',
                    'Gotv Jolli',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Bouquet Price',
                    '₦3950',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Due Date',
                    'Mar 19/2024',
                  ),
               const Gap(15),
               Divider(),
               const Gap(15),
               _rowCard(
                    'Buy New Bouquet',
                    '',
                  ),
                  const Gap(15),
                _rowCard(
                    'Bouquet',
                    'GOtv MAX',
                  ),
                  const Gap(15),
                  _rowCard(
                    'Amount',
                    '₦3950',
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
                        title: Text('Wallet Balance (₦0.00)'),
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
                        title: Text('Mega Bonus (₦0.00)'),
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
                          builder: (context) => CableTransactionScreen(
                            amount:3900,
                            name: 'Gotv',
                            image: '"assets/images/gotv.png",',
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
          style: TextStyle(
            fontSize: 15,
            // fontFamily: AppFonts.manRope
          ),
        ),
      ],
    );
  }
}