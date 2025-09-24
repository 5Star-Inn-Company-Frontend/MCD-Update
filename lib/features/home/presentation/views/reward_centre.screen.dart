import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/features/home/presentation/views/giveaway_screen.dart';
import 'package:mcd/features/home/presentation/views/leaderboard_screen.dart';

class RewardCentreScreen extends StatelessWidget {
  const RewardCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Reward Centre",
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child:GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GiveawayScreen()));
                },
                child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: _boxCard('assets/icons/hold-seeds-filled.png', "Give away", 'Create and claim giveaways')),
              ),
              AspectRatio(
                  aspectRatio: 3 / 2,
                  child: _boxCard('assets/icons/hold-seeds-filled.png', "Free Money", 'Watch advert and get paid for it')),
              AspectRatio(
                  aspectRatio: 3 / 2,
                  child: _boxCard('assets/icons/hold-seeds-filled.png', "Promo Code", 'Watch advert and get promo code')),
              AspectRatio(
                  aspectRatio: 3 / 2,
                  child: _boxCard('assets/icons/hold-seeds-filled.png', "Spin & Win", 'spin and win airtime,data and more')),
              InkWell(
                  onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  const UserStatsPage()));
                },
                child: AspectRatio(
                    aspectRatio: 3 / 5,
                    child: _boxCard('assets/icons/hold-seeds-filled.png', "Leaderboard", 'Earn extra rewards and climb to ranks to become a to MCD customer')),
              ),
              AspectRatio(
                  aspectRatio: 3 / 2,child: _boxCard('assets/icons/hold-seeds-filled.png', "Game Centre", 'Play games and earn money')),
          ],
        ),
      ),
    );
  }

  Widget _boxCard(String image, String title, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          color: const Color(0xffF3FFF7),
          border: Border.all(color: const Color(0xffF0F0F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            image,
            width: 26,
            height: 26,
          ),
          const Gap(10),
          TextSemiBold(
            title,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          const Gap(12),
          Text(
            text,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  // List<Widget> items = [
  //   _boxCard('assets/icons/hold-seeds-filled.png', "Give away", 'Create and claim giveaways'),
  //   _boxCard('assets/icons/hold-seeds-filled.png', "Free Money", 'Watch advert and get paid for it'),
  //   _boxCard('assets/icons/hold-seeds-filled.png', "Promo Code", 'Watch advert and get promo code'),
  //   _boxCard('assets/icons/hold-seeds-filled.png', "Spin & Win", 'spin and win airtime,data and more'),
  //   _boxCard('assets/icons/hold-seeds-filled.png', "Leaderboard", 'Earn extra rewards and climb to ranks to become a to MCD customer'),
  //   _boxCard('assets/icons/hold-seeds-filled.png', "Game Centre", 'Play games and earn money'),
  // ]
}
