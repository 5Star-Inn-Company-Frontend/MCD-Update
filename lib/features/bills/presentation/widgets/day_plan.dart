import 'package:flutter/material.dart';
import 'package:mcd/app/styles/fonts.dart';

class DayPlanWidget extends StatefulWidget {
  const DayPlanWidget({super.key});

  @override
  State<DayPlanWidget> createState() => _DayPlanWidgetState();
}

class _DayPlanWidgetState extends State<DayPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10// Number of columns in the grid
      ),
      itemBuilder: (context, index) {
        return GridTile(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: Color(0xffF3FFF7),
                border: Border.all(color: Color(0xffF0F0F0)),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              children: [
                TextSemiBold("50mb", fontWeight: FontWeight.w600,),
                TextSemiBold("1Day", fontWeight: FontWeight.w500,),
                TextSemiBold("#50.00", fontWeight: FontWeight.w500,),
                TextSemiBold("#3 cash back", fontWeight: FontWeight.w500,)
              ],
            ),
          ),
        );
      },
    );
  }
}
