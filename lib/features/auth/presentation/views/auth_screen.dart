import 'package:flutter/material.dart';
import 'package:mcd/features/auth/presentation/views/create_account.screen.dart';
import 'package:mcd/features/auth/presentation/views/login_screen.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView(bool showSigIn) {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(toggleView: toggleView);
    } else {
      return CreateAccount(toggleView: toggleView);
    }
  }
}
