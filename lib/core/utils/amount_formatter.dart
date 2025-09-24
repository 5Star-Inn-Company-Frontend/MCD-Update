import 'dart:io';

import 'package:intl/intl.dart';

class AmountUtil {
  static String removeDotFromAmount(String amount) {
    if (amount.contains('.')) {
      return amount.split('.')[0];
    } else {
      return amount;
    }
  }

  static String removeSymbolFromAmount(String amount) {
    if (amount.contains('₦')) {
      return amount.replaceAll('₦', '');
    } else {
      return amount;
    }
  }

  static String removeAllSymbolFromAmount(String amount) {
    if (amount.contains('₦') || amount.contains(',')) {
      return amount.replaceAll('₦', '').replaceAll(',', '');
    } else {
      return amount;
    }
  }

  static String formatAmount(double value) {
    final prefix = Platform.isAndroid ? 'N' : '₦';
    final f = NumberFormat('$prefix#,##0', 'en_US');
    return f.format(value);
  }

  static String formatAmountToNaira(double value) {
   final naira  = String.fromCharCode(0x20A6); 
    final prefix = Platform.isAndroid ? naira : '₦';
    final f = NumberFormat('$prefix#,##0', 'en_US');
    return f.format(value);
  }

  static String formatFigure(double value) {
    final f = NumberFormat('#,##0', 'en_US');
    return f.format(value);
  }
}