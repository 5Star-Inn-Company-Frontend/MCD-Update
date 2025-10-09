import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:mcd/core/utils/flushbar_notification.dart';
import 'package:mcd/features/home/presentation/views/home_navigation.dart';
import 'dart:developer' as dev;

class SetFingerPrint extends StatefulWidget {
  const SetFingerPrint({super.key});

  @override
  State<SetFingerPrint> createState() => _SetFingerPrintState();
}

class _SetFingerPrintState extends State<SetFingerPrint> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool _isBiometricAvailable = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      _isBiometricAvailable = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
      print(e);
    }
  }

  Future<void> _authenticate() async {
    try {
      _isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate with biometrics',
        options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: false, stickyAuth: true));
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        FlushbarNotification.showErrorMessage(context, message: "Fingerprint is not available");
      }
      if (e.code == auth_error.notEnrolled) {
        FlushbarNotification.showErrorMessage(context, message: "Fingerprint is not available");
      }
    }
    setState(() {
      if (_isAuthenticated == true) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeNavigation()),
              (Route<dynamic> route) => true);
      }
    });

    dev.log('fingerprint button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      disabled: _isBiometricAvailable == false ? true : false,
      onTap: _authenticate,
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Image.asset(AppAsset.faceId, width: 50,)),
      ),
    );
  }
}