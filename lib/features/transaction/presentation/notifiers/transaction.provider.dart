import 'package:flutter/material.dart';
import 'package:mcd/core/utils/logger.dart';

class TransactionNotifier extends ChangeNotifier {
  final TransactionState _transactionState = TransactionState();

  TransactionState get transactionState => _transactionState;

  void toggleGenerating() {
    _transactionState.toggleGenerating();
    notifyListeners();
  }

  void toggleDisbaled() {
    _transactionState.toggleDisabled();
    notifyListeners();
  }

  void toggleFormValid(bool value) {
    _transactionState.toggelUssdFormValid(value);
    notifyListeners();
  }
}

class TransactionState {
  bool _isGenerating = false;
  bool _isDisabled = true;

  bool get isGenerating => _isGenerating;

  bool get isDisabled => _isDisabled;

  final bool _iUssdFormValid = false;
  bool get iUssdFormValid => _iUssdFormValid;

  void toggelUssdFormValid(bool value) {
    logger.d(value);
    _isGenerating = value;
  }

  void toggleGenerating() {
    _isGenerating = !_isGenerating;
  }

  void toggleDisabled() {
    _isDisabled = !_isDisabled;
  }
}
