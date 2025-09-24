import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/models/item_model.dart';
import 'package:mcd/features/shop/presentation/views/order_history_tabs/order_tab.dart';

class DoneTab extends StatefulWidget {
  const DoneTab({super.key});

  @override
  State<DoneTab> createState() => _DoneTabState();
}

class _DoneTabState extends State<DoneTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: [
              const Gap(10),
              SizedBox(
                height: screenHeight(context) * 0.9,
                child: ListView.builder(
                  itemCount: orderHistoryList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        itemOrderWidget(orderHistoryList[index]),
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        )
      )
    );
  }

  Widget itemOrderWidget(OrderHistory order) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${order.date}, ${order.time}', style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1))),
                const Gap(15),
                Row(
                  children: [
                    Container(
                      width: screenWidth(context) * 0.03,
                      height: screenHeight(context) * 0.015,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(119, 119, 119, 1),
                        shape: BoxShape.circle
                      ),
                    ),
                    const Gap(5),
                    Text(order.address, style: GoogleFonts.poppins(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                  ],
                ),
                const Gap(5),
                Row(
                  children: [
                    Container(
                      width: screenWidth(context) * 0.03,
                      height: screenHeight(context) * 0.015,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(76, 175, 80, 1),
                        shape: BoxShape.circle
                      ),
                    ),
                    const Gap(5),
                    Text('6391 Elgin St. Celina, Delaware 10299', style: GoogleFonts.poppins(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                  ],
                ),
                const Gap(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.shopping_bag, color: Color.fromRGBO(90, 187, 123, 1)),
                    const Gap(5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.itemName, style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                        Text(order.itemSubName, style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(119, 119, 119, 1))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(order.image),
                ),
                Row(
                  children: [
                    Text("(${order.numOfItem} item)", style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                    const Gap(5),
                    Container(
                      width: screenWidth(context) * 0.03,
                      height: screenHeight(context) * 0.015,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(57, 81, 133, 1),
                        shape: BoxShape.circle
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Gap(5),
        const Divider(),
        const Gap(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OrderTab()));
              },
              child: Text('ORDER AGAIN', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(90, 187, 123, 1)))
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#400.00', style: GoogleFonts.poppins(fontSize: 9.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1))),
                Text('#450.00', style: GoogleFonts.poppins(fontSize: 6.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(119, 119, 119, 1))),
              ],
            ),
          ],
        ),
        const Gap(20)
      ],
    );
  }
}