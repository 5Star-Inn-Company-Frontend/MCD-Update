import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/leaderboard_module/leaderboard_module_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';

class LeaderboardModulePage extends GetView<LeaderboardModuleController> {
  const LeaderboardModulePage({super.key});

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
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(controller.topUserImage),
                              radius: 30,
                            ),
                            const SizedBox(width: 20.0),
                            Text(
                              controller.topUserName,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              controller.topUserScore,
                              style: const TextStyle(
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
                        children: [],
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