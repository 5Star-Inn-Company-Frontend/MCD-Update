import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/pos/presentation/views/pos_upload_location_screen.dart';
import 'package:mcd/features/pos/presentation/widgets/pos_dropdown.dart';

class PosTermReqFormScreen extends StatefulWidget {
  const PosTermReqFormScreen({super.key});

  @override
  State<PosTermReqFormScreen> createState() => _PosTermReqFormScreenState();
}

class _PosTermReqFormScreenState extends State<PosTermReqFormScreen> {
  final TextEditingController addressDeliveryController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? terminalType;
  String? purchaseType;
  String? accountType;
  String? numOfPos;
  String? selectState;
  String? selectCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Request For Terminal",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            PosDropdown(
              ddname: 'Terminal Type', selectedValue: terminalType, listdd: const [
                DropdownMenuItem(value: 'K11 Terminal', child: Text('K11 Terminal')),
                DropdownMenuItem(value: 'MP5SP Terminal', child: Text('MP5SP Terminal')),
              ], 
            ),

            Gap(10.h),

            PosDropdown(
              ddname: 'Select Purchase Type', selectedValue: purchaseType, listdd: const [
                DropdownMenuItem(value: 'Outright Purchase', child: Text('Outright Purchase')),
                DropdownMenuItem(value: 'Lease Purchase', child: Text('Lease Purchase')),
              ],
            ),

            Gap(10.h),

            PosDropdown(
              ddname: 'Number of POS', selectedValue: numOfPos, listdd: const [
                DropdownMenuItem(value: '1', child: Text('1')),
                DropdownMenuItem(value: '2', child: Text('2')),
                DropdownMenuItem(value: '3', child: Text('3')),
              ],
            ),

            Gap(10.h),

            PosDropdown(
              ddname: 'Account Type', selectedValue: accountType, listdd: const [
                DropdownMenuItem(value: 'Agent', child: Text('Agent')),
                DropdownMenuItem(value: 'Savings', child: Text('Savings')),
                DropdownMenuItem(value: 'Current', child: Text('Current')),
              ],
            ),

            Gap(10.h),

            textfieldWidget(addressDeliveryController, 'Address For Delivery'),

            Gap(10.h),

            PosDropdown(
              ddname: 'Select State', selectedValue: selectState, listdd: const [
                DropdownMenuItem(value: 'Lagos', child: Text('Lagos')),
                DropdownMenuItem(value: 'Abuja', child: Text('Abuja')),
                DropdownMenuItem(value: 'Kano', child: Text('Kano')),
              ],
            ),

            Gap(10.h),

            PosDropdown(
              ddname: 'Select City', selectedValue: selectCity, listdd: const [
                DropdownMenuItem(value: 'Ikeja', child: Text('Ikeja')),
                DropdownMenuItem(value: 'Lekki', child: Text('Lekki')),
                DropdownMenuItem(value: 'Victoria Island', child: Text('Victoria Island')),
              ],
            ),

            Gap(10.h),

            textfieldWidget(contactNameController, 'Contact Name'),

            Gap(10.h),

            textfieldWidget(contactEmailController, 'Contact Email'),

            Gap(10.h),

            textfieldWidget(phoneNumberController, 'Phone Number'),

            Gap(9.h),

            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosUploadLocationScreen()));
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Proceed', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
              ),
            ),)
          ]
        )
      )
    );
  }

  Widget textfieldWidget(TextEditingController? controller, String tfieldname) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(tfieldname, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
          ],
        ),
        Gap(5.h),
        TextField(
          controller: controller,
          style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
          cursorColor: const Color.fromRGBO(112, 112, 112, 1),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(112, 112, 112, 1))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(120, 120, 120, 1))
            ),
          ),
        ),
      ],
    );
  }
}