import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mcd/core/navigators/routes_name.dart';
import 'package:mcd/features/agent_request/presentation/pages/agent_profile_details.dart';
import 'package:mcd/features/auth/presentation/views/auth_screen.dart';
import 'package:mcd/features/auth/presentation/views/reset_password_screen.dart';
import 'package:mcd/features/auth/presentation/views/verify_otp_screen.dart';
import 'package:mcd/features/bills/presentation/views/airtime_bill.screen.dart';
import 'package:mcd/features/bills/presentation/views/airtime_to_cash.dart';
import 'package:mcd/features/bills/presentation/views/betting_bill.screen.dart';
import 'package:mcd/features/bills/presentation/views/cable_tv_screen.dart';
import 'package:mcd/features/bills/presentation/views/data_bill.screen.dart';
import 'package:mcd/features/bills/presentation/views/electricity.screen.dart';
import 'package:mcd/features/bills/presentation/views/epin_screen.dart';
import 'package:mcd/features/bills/presentation/views/jamb_screen.dart';
import 'package:mcd/features/home/presentation/views/home_navigation.dart';
import 'package:mcd/features/home/presentation/views/leaderboard_screen.dart';
import 'package:mcd/features/home/presentation/views/nin_validation_screen.dart';
import 'package:mcd/features/home/presentation/views/result_checker_screen.dart';
import 'package:mcd/features/home/presentation/views/reward_centre.screen.dart';
import 'package:mcd/features/pos/presentation/views/pos_home_screen.dart';

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: Routes.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeNavigation();
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.authenticate,
          builder: (BuildContext context, GoRouterState state) {
            return Authenticate();
          },
        ),
        GoRoute(
          path: Routes.verifyOtp,
          name: Routes.verifyOtp,
          builder: (BuildContext context, GoRouterState state) {
            return const VerifyOtpScreen(email: '',);
          },
        ),
        GoRoute(
          path: Routes.resetPassword,
          name: Routes.resetPassword,
          builder: (BuildContext context, GoRouterState state) {
            return const ResetPasswordScreen();
          },
        ),
        GoRoute(
          path: Routes.agentProfileInfo,
          name: Routes.agentProfileInfo,
          builder: (BuildContext context, GoRouterState state) {
            return const AgentProfileInfoScreen();
          },
        ),
        GoRoute(
          path: Routes.rewardCentre,
          name: Routes.rewardCentre,
          builder: (BuildContext context, GoRouterState state) {
            return const RewardCentreScreen();
          },
        ),
        GoRoute(
          path: Routes.airtimeBill,
          name: Routes.airtimeBill,
          builder: (BuildContext context, GoRouterState state) {
            return const AirtimeBillScreen();
          },
        ),
        GoRoute(
          path: Routes.bettingBill,
          name: Routes.bettingBill,
          builder: (BuildContext context, GoRouterState state) {
            return const BettingBillScreen();
          },
        ),
        GoRoute(
          path: Routes.dataBill,
          name: Routes.dataBill,
          builder: (BuildContext context, GoRouterState state) {
            return const DataBillScreen();
          },
        ),
        GoRoute(
          path: Routes.electricity,
          name: Routes.electricity,
          builder: (BuildContext context, GoRouterState state) {
            return const ElectricityScreen();
          },
        ),
        GoRoute(
          path: Routes.epin,
          name: Routes.epin,
          builder: (BuildContext context, GoRouterState state) {
            return const EpinScreen();
          },
        ),
        GoRoute(
          path: Routes.ninValidation,
          name: Routes.ninValidation,
          builder: (BuildContext context, GoRouterState state) {
            return const NinValidationScreen();
          },
        ),
        GoRoute(
          path: Routes.resultChecker,
          name: Routes.resultChecker,
          builder: (BuildContext context, GoRouterState state) {
            return const ResultCheckerScreen();
          },
        ),
        GoRoute(
          path: Routes.cableTv,
          name: Routes.cableTv,
          builder: (BuildContext context, GoRouterState state) {
            return const CableTvScreen();
          },
        ),
        GoRoute(
          path: Routes.leaderboard,
          name: Routes.leaderboard,
          builder: (BuildContext context, GoRouterState state) {
            return const UserStatsPage();
          },
        ),
        GoRoute(
          path: Routes.airtime2cash,
          name: Routes.airtime2cash,
          builder: (BuildContext context, GoRouterState state) {
            return const Airtime2Cash();
          },
        ),
        GoRoute(
          path: Routes.jamb,
          name: Routes.jamb,
          builder: (BuildContext context, GoRouterState state) {
            return const JambScreen();
          },
        ),
        GoRoute(
          path: Routes.pos,
          name: Routes.pos,
          builder: (BuildContext context, GoRouterState state) {
            return const PosHomeScreen();
          },
        )
      ],
    ),
  ],
);
