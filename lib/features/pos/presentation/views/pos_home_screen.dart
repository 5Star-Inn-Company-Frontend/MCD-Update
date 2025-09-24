import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/pos/presentation/views/pos_map_term_screen.dart';
import 'package:mcd/features/pos/presentation/views/pos_request_new_term_screen.dart';
import 'package:mcd/features/pos/presentation/views/pos_terminal_requests_screen.dart';
import 'package:mcd/features/pos/presentation/views/terminal_details_screen.dart';

class PosHomeScreen extends StatefulWidget {
  const PosHomeScreen({super.key});

  @override
  State<PosHomeScreen> createState() => _PosHomeScreenState();
}

class _PosHomeScreenState extends State<PosHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
           Container(
            height: screenHeight(context) * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(90, 187, 123, 1),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('My Terminal', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(251, 251, 251, 1)),),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosRequestNewTermScreen()));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: screenHeight(context) * 0.09,
                          width: screenWidth(context) * 0.35,
                          child: ColoredBox(
                            color: const Color.fromRGBO(222, 217, 242, 0.15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset('assets/icons/card-pos.svg'),
                                Text('Request new terminal', style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTerminalRequestsScreen()));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4), 
                        child: SizedBox(
                          height: screenHeight(context) * 0.09,
                          width: screenWidth(context) * 0.35,
                          child: ColoredBox(
                            color: const Color.fromRGBO(222, 217, 242, 0.15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset('assets/icons/card-pos.svg'),
                                Text('Terminal Requests', style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          const Gap(15),

          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosMapTermScreen()));
            },
            child: Container(
              height: screenHeight(context) * 0.065,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromRGBO(34, 197, 94, 1), width: 1),
              ),
              child: Center(child: Text('Map new Device', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(34, 197, 94, 1)),),),
            ),
          ),

          const Gap(30),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Active Terminals', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
            ],
          ),

          const Gap(15),

          SizedBox(
            height: screenHeight(context) * 0.27,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TerminalDetailsScreen()));},
                      child: Container(
                        height: screenHeight(context) * 0.08,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                  width: screenWidth(context) * 0.1,
                                  child: CircleAvatar(
                                    backgroundColor: const Color.fromRGBO(246, 244, 255, 1),
                                    child: SvgPicture.asset('assets/icons/terminal-phone-icon.svg'),
                                  ),
                                ),
                                const Gap(20),                    
                                Text('2033QW9-', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1))),
                              ],
                            ),
                      
                            IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_right_rounded, color: Color.fromRGBO(112, 112, 112, 1), size: 40)),
                          ],
                        )
                      ),
                    ),
                    const Gap(10)
                  ],
                );
              }
            ),
          ),

          const Gap(30),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Inactive Terminals', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
            ],
          ),

          const Gap(15),

          SizedBox(
            height: screenHeight(context) * 0.5,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: screenHeight(context) * 0.08,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                  width: screenWidth(context) * 0.1,
                                  child: CircleAvatar(
                                    backgroundColor: const Color.fromRGBO(246, 244, 255, 1),
                                    child: SvgPicture.asset('assets/icons/terminal-phone-icon.svg'),
                                  ),
                                ),
                                const Gap(20),                    
                                Text('2033QW9-', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1))),
                              ],
                            ),
                      
                            IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_right_rounded, color: Color.fromRGBO(112, 112, 112, 1), size: 40)),
                          ],
                        )
                      ),
                    ),
                    const Gap(10)
                  ],
                );
              }
            ),
          )


          ]
        )
      )
    );
  }
}