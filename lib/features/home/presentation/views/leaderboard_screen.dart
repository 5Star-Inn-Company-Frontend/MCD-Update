import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';

class UserStatsPage extends StatelessWidget {
  const UserStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: 'Leaderboard',
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 224,
                color: AppColors.lightBlue,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 122,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/debbie.png'),
                              radius: 30,
                            ),
                            SizedBox(width: 20.0),
                            Text(
                              'Debbie',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '2430',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColor),
                      child: const Stack(
                        children: [
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Column(
                          //     children: [
                          //       CircleAvatar(
                          //         backgroundImage: AssetImage('assets/lucy.jpg'),
                          //         radius: 30,
                          //       ),
                          //       SizedBox(width: 16.0),
                          //       Text(
                          //         'Lucy',
                          //         style: TextStyle(
                          //           fontSize: 12.0,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),

                          //       Text(
                          //         '1847',
                          //         style: TextStyle(
                          //           fontSize: 15.0,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Column(
                          //     children: [
                          //       CircleAvatar(
                          //         backgroundImage: AssetImage('assets/joseph.jpg'),
                          //         radius: 30,
                          //       ),
                          //       SizedBox(width: 16.0),
                          //       Text(
                          //         'Joseph',
                          //         style: TextStyle(
                          //           fontSize: 18.0,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),

                          //       Text(
                          //         '1674',
                          //         style: TextStyle(
                          //           fontSize: 18.0,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
