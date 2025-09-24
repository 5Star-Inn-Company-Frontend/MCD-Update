import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/confirm_or_edit_upload_market_screen.dart';

class UploadMarketScreen extends StatefulWidget {
  const UploadMarketScreen({super.key});

  @override
  State<UploadMarketScreen> createState() => _UploadMarketScreenState();
}

class _UploadMarketScreenState extends State<UploadMarketScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDetailsController = TextEditingController();
  TextEditingController keyFeaturesController = TextEditingController();
  TextEditingController whatIsTheBoxController = TextEditingController();
  TextEditingController productspecificationsController = TextEditingController();

  String? selectedFileName;
  bool fileUploaded = false;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        fileUploaded = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Upload Your Market', centerTitle: false,),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(30.h),
          
              Text('Product Pictures', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(10.h),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _fileUploadContainer(),
                  _fileUploadContainer(),
                  _fileUploadContainer(),
                ],
              ),
          
              Gap(20.h),
          
              Text('Product Name', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(10.h),
          
              TextFormField(
                controller: productNameController,
                cursorColor: const Color.fromRGBO(0, 0, 0, 1),
                style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),
                decoration: InputDecoration(
                  hintStyle: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color.fromRGBO(135, 135, 135, 1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color.fromRGBO(135, 135, 135, 1)),
                  ),
                ),
              ),
          
              Gap(20.h),
          
              uploadMarketTextField('Product Details', productDetailsController),
          
              Gap(20.h),
          
              uploadMarketTextField('Key Features', keyFeaturesController),
          
              Gap(20.h),
          
              uploadMarketTextField('What is the box?', whatIsTheBoxController),
          
              Gap(20.h),
          
              uploadMarketTextField('Product Specifications', productspecificationsController),
          
              Gap(30.h),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                      ConfirmOrEditUploadMarketScreen(
                        productNameController: productNameController.text,
                        productDetailsController: productDetailsController.text,
                        keyFeaturesController: keyFeaturesController.text,
                        whatIsTheBoxController: whatIsTheBoxController.text,
                        productspecificationsController: productspecificationsController.text,
                      )));
                    },
                    child: Container(
                      height: 30.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(90, 187, 123, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(
                        'SUBMIT',
                        style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ),),
                ],
              )
          
            ]
          )
        )
      )
    );
  }

  Widget _fileUploadContainer() {
    return GestureDetector(
      onTap: selectFile,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [8, 4],
        strokeWidth: 3,
        color:  const Color.fromRGBO(90, 187, 123, 1),
        child: SizedBox(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: fileUploaded ? 
              const Icon(Icons.check, size: 50, color: Color.fromRGBO(51, 160, 88, 1))
              : const Icon(Icons.add, size: 50, color: Color.fromRGBO(51, 160, 88, 1)
          ) 
        ))
      ),
    );
  }

  Widget uploadMarketTextField(String name, TextEditingController? controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),

        Gap(10.h),

        TextFormField(
          minLines: 1,
          maxLines: 5,
          controller: controller,
          cursorColor: const Color.fromRGBO(0, 0, 0, 1),
          style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),
          decoration: InputDecoration(
            hintStyle: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(135, 135, 135, 1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(135, 135, 135, 1)),
            ),
          ),
        ),
      ],
    );
  }
}