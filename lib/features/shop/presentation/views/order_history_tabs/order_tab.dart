import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_appbar.dart';
import 'package:mcd/features/shop/presentation/widgets/shop_drawer.dart';

class OrderTab extends StatefulWidget {
  const OrderTab({super.key});

  @override
  State<OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  int _currentStep = 0;
  List<Step> steps = [
    const Step(
        title: Text(''),
        content: Text(''),
        // isActive: false,
    ),
    const Step(
        title: Text(''),
        content: Text(''),
        // isActive: false,
    ),
    const Step(
        title: Text(''),
        content: Text(''),
        // isActive: false,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      drawer: const ShopDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Order', style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)))
                ]
              ),
              const Gap(20),
              // FlutterSteps(
              //   steps: steps,
              //   titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              //   titleFontSize: 9.sp,
              //   showSubtitle: false,
              //   isStepLineContinuous: false,
              //   activeColor: const Color.fromRGBO(90, 187, 123, 1),
              //   inactiveColor: const Color.fromRGBO(200, 200, 200, 1),
              //   titleActiveColor: const Color.fromRGBO(90, 187, 123, 1),
              //   titleInactiveColor: const Color.fromRGBO(200, 200, 200, 1),
              //   activeStepLineColor: const Color.fromRGBO(90, 187, 123, 1),
              //   inactiveStepLineColor: const Color.fromRGBO(200, 200, 200, 1),
              // ),
              Stepper(
                type: StepperType.horizontal,
                steps: steps,
                onStepTapped: (int index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep != 2) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep != 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
              )
            ]
          ),
        )
      )
    );
  }
}