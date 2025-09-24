import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Functions {

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  static String getFormattedDate(DateTime dateTime) {
    return DateFormat('yMd').format(dateTime).toString();
  }

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  static String getFormattedTime(DateTime dateTime) {
    return DateFormat('h:mm').format(dateTime).toString();
  }

  /// Method to capitalize the first letter of each word in [string]
  static String capitalize(String string) {
    String result = '';

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = [];

      if(values.length == 1){
        result = string[0].toUpperCase() + string.substring(1);
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase() + values[i].substring(1));
          }
        }
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  /// Method to get the first letter of each word in [string], maximum of 2
  /// letters to return
  static String profileName(String string) {
    String result = '';

    if (string.isEmpty) {
      return '';
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = [];

      if(values.length == 1){
        result = string[0];
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase());
          }
        }
        List<String> initials = [];
        if(valuesToJoin.length >= 2) {
          initials = [valuesToJoin[0] ?? '', valuesToJoin[1] ?? ''];
        }
        else {
          initials = [valuesToJoin[0] ?? ''];
        }
        result = initials.join(' ');
      }

    }
    return result;
  }

  /// Convert a double [value] to a currency
  static String money(double value, String currency){
    final nf = NumberFormat("#,##0.00", "en_US");
    return '$currency${nf.format(value)}';
  }

  /// Function to show success message with [_showAlert]
  static showSuccess(BuildContext context, String message, {bool shouldDismiss = true, Function? where}) {
    Timer.run(() => _showAlert(
        context,
        message,
        Color(0xFFE2F8FF),
        CupertinoIcons.check_mark_circled_solid,
        Color.fromRGBO(91, 180, 107, 1),
        shouldDismiss,
        where: where!
    ));
  }

  /// Function to show info message with [_showAlert]
  static showInfo(BuildContext context, String message, {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(
        context,
        message,
        Color(0xFFE7EDFB),
        Icons.info_outline,
        Color.fromRGBO(54, 105, 214, 1),
        shouldDismiss
    ));
  }

  /// Function to show error message with [_showAlert]
  static showError(BuildContext context, String message, {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(
        context,
        message,
        Color(0xFFFDE2E1),
        Icons.error_outline,
        Colors.red,
        shouldDismiss
    ));
  }

  static show(BuildContext context, String message, {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(
        context,
        message,
        Color(0xFFFDE2E1),
        Icons.gpp_good_sharp,
        Color.fromRGBO(91, 180, 107, 1),
        shouldDismiss
    ));
  }

  /// Building a custom general dialog for my toast message with dynamic details
  static _showAlert(BuildContext context, String message, Color color, IconData icon, Color iconColor, bool shouldDismiss, {Function? where}) {
    if(message.isEmpty || message.runtimeType != String) return;
    bool opened = true;
    shouldDismiss = true;
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        useRootNavigator: false,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          if(shouldDismiss){
            Future.delayed(const Duration(milliseconds: 2500), () {
              Navigator.of(context, rootNavigator: true).pop();
            }).then((value) {
              if(icon == CupertinoIcons.check_mark_circled_solid){
                where;
              }
              where;
            });
          }
          return Material(
            type: MaterialType.transparency,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                              bottom: Radius.circular(10)
                          ),
                          color: color
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            icon,
                            size: 30,
                            color: iconColor,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                message,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}