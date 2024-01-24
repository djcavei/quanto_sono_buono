import 'package:flutter/services.dart';

class DecimalNumberRegexInputFormatter extends TextInputFormatter {
  final _regex = RegExp(r'^[1-9]\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return _regex.hasMatch(newValue.text) || newValue.text == '' ? newValue : oldValue;
  }

}